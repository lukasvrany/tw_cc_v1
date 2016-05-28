//
//  ProgressController.swift
//  tw_cc_v1
//
//  Created by EN on 26.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import SwiftyJSON
import HealthKit


class ProgressController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

	var webView: WKWebView?

	var mail: String!
	var name: String!
	var address: String!
	var city: String!
	var zip: String!
	var phone: String!
	var price: String!

    var healthManager:HealKitData = HealKitData()
    var weightValue: Double! = 0.0
    var heightValue: Double! = 0.0
    var stevarlue: Double! = 0.0
    var cycleValue: Double! = 0.0
    var distanceValue: Double! = 0.0
    var sleepValue: Double! = 0.0
    var stepValue: Double! = 0.0
    var healtkitInfo = [String:String]()
    var healthkitAvailable: Bool = false

	var progressViewBig: UIImageView!
	var progressViewSmall: UIImageView!
	var angle: CGFloat = 0
	var timer: NSTimer?

	var redirTimer: NSTimer?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Vyhodnocování"
		self.view.backgroundColor = UIColor.whiteColor()
		self.navigationItem.setHidesBackButton(true, animated: false)

		let profile: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "rightIcon")!, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
		self.navigationItem.setRightBarButtonItem(profile, animated: true)

		let more: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftIcon")!, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
		self.navigationItem.setLeftBarButtonItem(more, animated: true)

		timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(ProgressController.rotateWheel), userInfo: nil, repeats: true)

		progressViewBig = UIImageView(image: UIImage(named: "big"))
		progressViewBig.contentMode = UIViewContentMode.ScaleAspectFit
		self.view.addSubview(progressViewBig)
		progressViewBig.snp_makeConstraints { (make) in
			make.center.equalTo(self.view)
			make.width.equalTo(150)
			make.height.equalTo(150)
		}

		progressViewSmall = UIImageView(image: UIImage(named: "small"))
		progressViewSmall.contentMode = UIViewContentMode.ScaleAspectFit
		self.view.addSubview(progressViewSmall)
		progressViewSmall.snp_makeConstraints { (make) in
			make.center.equalTo(self.view).offset(-80)
			make.width.equalTo(75)
			make.height.equalTo(75)
		}

		let progressLabel = UILabel()
		progressLabel.text = "Probíhá vyhodnocení"
		progressLabel.font = UIFont(name: "HelveticaNeue", size: 25)
		progressLabel.textAlignment = .Center
		self.view.addSubview(progressLabel)
		progressLabel.snp_makeConstraints { (make) in
			make.top.equalTo(self.snp_topLayoutGuideBottom).offset(20)
			make.leading.equalTo(10)
			make.trailing.equalTo(-10)
		}
        
        healthkitAvailable = healthManager.healkitIsAvailable()
        if (healthkitAvailable){
            healtkitInfo = healthManager.getInformation()
            updateHealthInfo()
        }
		
        sendRequestToNikita()
        
		redirTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: #selector(results), userInfo: nil, repeats: true)

	}

    func updateHealthInfo() {
        updateWeight()
        updateHeight()
        updateSteps()
        updateCycleDistance()
        updateDistance()
//        updateSleep()
    }

//    private func updateSleep()
//    {
//        var sleeps:HKQuantitySample?
//
//        let sleepType = HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)
//
//        let dateFormatter = NSDateFormatter()
//
//        let start = dateFormatter.dateFromString("2016-05-26")! as NSDate
//        let end = dateFormatter.dateFromString("2016-05-27")! as NSDate
//
////        let fuck = NSDate(
//
//        let predicate = HKQuery.predicateForSamplesWithStartDate(start, endDate: end, options: .None)
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//        let query = HKSampleQuery(sampleType: sleepType!, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
//            if let result = tmpResult {
//                for item in result {
//                    if let sample = item as? HKCategorySample {
//                        let value = (sample.value == HKCategoryValueSleepAnalysis.InBed.rawValue) ? "InBed" : "Asleep"
//                        print("sleep: \(sample.startDate) \(sample.endDate) - source: \(sample.source.name) - value: \(value)")
//                        let seconds = sample.endDate.timeIntervalSinceDate(sample.startDate)
//                        let minutes = seconds/60
//                        let hours = minutes/60
//                    }
//                }
//            }
//        }
//
//        self.healthManager.healthKitStore.executeQuery(query)
//    }

    private func updateDistance()
    {
        var distances:HKQuantitySample?

        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)

        self.healthManager.readMostRecentSample(sampleType!, completion: { (recentSex, error) -> Void in

            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }

            distances = recentSex as? HKQuantitySample
            if let distance = distances?.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo)) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.distanceValue = distance
                });
            }
        });
    }

    private func updateCycleDistance()
    {
        var distances:HKQuantitySample?

        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)

        self.healthManager.readMostRecentSample(sampleType!, completion: { (recentSex, error) -> Void in

            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }

            distances = recentSex as? HKQuantitySample
            if let distance = distances?.quantity.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo)) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.cycleValue = distance
                });
            }
        });
    }

    private func updateSteps()
    {
        var steps:HKQuantitySample?

        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)

        self.healthManager.readMostRecentSample(sampleType!, completion: { (recentSex, error) -> Void in

            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }

            steps = recentSex as? HKQuantitySample
            if let step = steps?.quantity.doubleValueForUnit(HKUnit.countUnit()) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stepValue = step
                });
            }
        });
    }

    private func updateHeight()
    {
        var height:HKQuantitySample?

        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)

        self.healthManager.readMostRecentSample(sampleType!, completion: { (mostRecentHeight, error) -> Void in

            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }

            height = mostRecentHeight as? HKQuantitySample
            if let meters = height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.heightValue = meters
                });
            }
        });
    }

    func updateWeight()
    {
        var weight:HKQuantitySample?

        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)

        self.healthManager.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in

            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }

            weight = mostRecentWeight as? HKQuantitySample
            if let kilograms = weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.weightValue = kilograms
                });
            }
        });
    }

    func calculateBMIWithWeightInKilograms(weightInKilograms:Double, heightInMeters:Double) -> Double?
    {
        if heightInMeters == 0 {
            return nil;
        }
        return (weightInKilograms/(heightInMeters*heightInMeters));
    }

	func sendRequestToNikita() {
		// the following code is used to execute custom javascript
		// in the webview to initialize the webviewer object
		let contentController = WKUserContentController()
		let userScript = WKUserScript(
			source: "window.webviewer.init()",
			injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
			forMainFrameOnly: true
		)
		contentController.addUserScript(userScript)

		// this code to used to allow the webview to send messages to swift
		// via: webkit.messageHandlers.callbackHandler.postMessage(message);
		contentController.addScriptMessageHandler(
			self,
			name: "callbackHandler"
		)

		let config = WKWebViewConfiguration()
		config.userContentController = contentController

		// create the webview with the above configuration options
		self.webView = WKWebView(frame: self.view.frame, configuration: config)
		// self.view = self.webView

		let url = NSURL(string: "http://146.185.175.250:5000/")
		let req = NSURLRequest(URL: url!)
		webView!.loadRequest(req)

		webView!.hidden = true
		self.view.addSubview(webView!)
		webView!.snp_makeConstraints { make in
			make.edges.equalTo(view)
		}
		webView!.navigationDelegate = self

	}

	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {

		// when the webview has finished loading, send it a message via javascript
		// First call Nikita
		print("call")
		self.webView!.evaluateJavaScript("submit('\(mail)', '\(name)', '\(price)', '\(address)', '\(city)', '\(zip)', '\(phone)');", completionHandler: nil)
	}

	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let jsonString = String(message.body)
		print(jsonString)
		let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
		let json = JSON(data: data)


		if json["id"].string != nil {
			// Response from nikita
			print("check response")
			Collector.Instance().response_info = json
			Collector.Instance().validResponseFromNikita = true
			timer!.invalidate()
			results()
		} else if json["transaction_id"].string != nil {
			// First response from nikita. If contains transaction_id then call is success, else fails
			// Call checkRespons and get response from Nikita
			print("submit response")
			self.webView!.evaluateJavaScript("checkResult();", completionHandler: nil)
		} else {
			// Something goes wrong -> back to form or continue???
			Collector.Instance().validResponseFromNikita = false
			timer!.invalidate()
			results()
		}

		print("konec")

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func results() {
        
        if (healthkitAvailable) {
            healtkitInfo["weight"] = self.weightValue.description + " Kg"
            healtkitInfo["height"] = self.heightValue.description + " m"
            healtkitInfo["bmi"] = self.calculateBMIWithWeightInKilograms(weightValue, heightInMeters: heightValue)?.description
            healtkitInfo["steps"] = self.stepValue.description
            healtkitInfo["cycleDistance"] = self.cycleValue.description + " Km"
            healtkitInfo["distance"] = self.distanceValue.description + "Km"
            
            Collector.Instance().healtkitData = healtkitInfo
        }
        
		redirTimer?.invalidate()
		navigationController?.pushViewController(ResultController(), animated: true)
	}

	func rotateWheel() {
		// set your angle here
		angle++
		self.progressViewBig.transform = CGAffineTransformMakeRotation((angle * CGFloat(M_PI)) / 180.0)
		self.progressViewSmall.transform = CGAffineTransformMakeRotation((-angle * CGFloat(M_PI)) / 180.0)
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */

}
