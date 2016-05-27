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
    var healthKitData = [String: String]()
    var test: String! = "fuck you bitch"

	var progressViewBig: UIImageView!
    var progressViewSmall: UIImageView!
    var angle:CGFloat = 0
    var timer:NSTimer?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Vyhodnocování"
		self.view.backgroundColor = UIColor.whiteColor()

		timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "rotateWheel", userInfo: nil, repeats: true)

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
        
        
//        let healtkit = HealKitData()
//        
        let isHealkitAvailable = healthManager.healkitIsAvailable()
        if (isHealkitAvailable){
            print(healthManager.getInformation())
        }
        
		/*
		 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProgressController.results))
		 view.addGestureRecognizer(tapGesture)
		 */
		sendRequestToNikita()
        updateHealthInfo()
        
//        print(self.healthKitData)
//        print(self.test)
	}
    
    func updateHealthInfo() {
        
//        updateProfileInfo();
        updateWeight();
//        updateHeight();
        
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
            
            var weightLocalizedString = "Unknow";
            
            weight = mostRecentWeight as? HKQuantitySample;
            if let kilograms = weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
                let weightFormatter = NSMassFormatter()
                weightFormatter.forPersonMassUse = true;
                weightLocalizedString = weightFormatter.stringFromKilograms(kilograms)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.healthKitData["weight"] = weightLocalizedString
            });
            self.test = "motherfucker"
            self.healthKitData["weight"] = weightLocalizedString
        });
        
        print(self.test)
//        var weight:HKQuantitySample?
        //
        //        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        //
        //        self.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
        //
        //            if( error != nil )
        //            {
        //                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
        //                return;
        //            }
        //
        //            var weightLocalizedString = "Unknow"
        //
        //            weight = mostRecentWeight as? HKQuantitySample;
        //            if let kilograms = weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
        //                let weightFormatter = NSMassFormatter()
        //                weightFormatter.forPersonMassUse = true;
        //                weightLocalizedString = weightFormatter.stringFromValue(kilograms, unit: NSMassFormatterUnit.Kilogram)
        //            }
        //
        ////            let test["wight"] = weightLocalizedString
        //            let weightInfo = [String: String]()
        //
        //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //                self.info["wight"] = weightLocalizedString
        //                self.postContentAddedInfo(weightInfo)
        //                
        //                
        //            });
        //            print(weightLocalizedString)
        //        });

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
        
        let healtkit = HealKitData()
print(healtkit.getPostData())
		print("konec")

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func results() {
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
