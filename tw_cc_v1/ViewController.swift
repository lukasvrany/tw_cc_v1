//
//  ViewController.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 19.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit
import PermissionScope

class ViewController: UIViewController, UITextFieldDelegate {

	let pscope = PermissionScope()

	// Pole vsech UITextField ve formalu.
	var allTextFields = [String: UITextField]()

	// Array obsahuje dalsi pole s ruznymi druhy informaci
	var allInformations = [String: [String: String]]()
	var motionInformations = [String: String]()
	var copyAndPaseInformations = [String: Bool]()

	weak var sendButton: UIButton!

	var gyroscope = Gyroscope()

	var mainTimer: Timer?

	override func viewWillDisappear(animated: Bool) {
		gyroscope.pauseGyroCollection()
	}

	override func viewWillAppear(animated: Bool) {
		if gyroscope.gyroGathering {
			gyroscope.startGyroCollection()
		}
	}

	override func loadView() {
		super.loadView()

		self.navigationController?.navigationBarHidden = false
		self.view.backgroundColor = UIColor.whiteColor()
		self.title = "Prověř si mě"

		self.navigationItem.setHidesBackButton(true, animated: false)
		self.view.backgroundColor = UIColor.whiteColor()

		let profile: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "rightIcon")!, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
		self.navigationItem.setRightBarButtonItem(profile, animated: true)

		let more: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftIcon")!, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
		self.navigationItem.setLeftBarButtonItem(more, animated: true)

		let btnSend = UIButton()
		btnSend.setTitle("Proklepnout", forState: .Normal)
		btnSend.backgroundColor = UIColor(netHex: 0x60cb54)
		btnSend.snp_makeConstraints { (make) in
			make.height.equalTo(50)
		}
		self.sendButton = btnSend

		let mainStackView = UIStackView(arrangedSubviews: [
			createStackHorizontalLine("Jmeno"),
			createStackHorizontalLine("Adresa"),
			createStackHorizontalLine("Mesto"),
			createStackHorizontalLine("PSČ"),
			createStackHorizontalLine("Tel"),
			createStackHorizontalLine("Mail"),
			createStackHorizontalLine("Pujcka"),
			btnSend])

		allTextFields["PSČ"]?.keyboardType = .DecimalPad
		allTextFields["Tel"]?.keyboardType = .DecimalPad
		allTextFields["Mail"]?.keyboardType = .EmailAddress
		allTextFields["Pujcka"]?.keyboardType = .DecimalPad

		mainStackView.axis = .Vertical
		mainStackView.spacing = 20
		self.view.addSubview(mainStackView)
		mainStackView.snp_makeConstraints { make in
			make.leading.equalTo(10)
			make.trailing.equalTo(-10)
			make.top.equalTo(snp_topLayoutGuideBottom).offset(20)
			make.bottom.lessThanOrEqualTo(self.view.snp_bottom).offset(-10)
		}

		pscope.headerLabel.text = "Ješte jedna věc"
		pscope.bodyLabel.text = "Potřebujeme pár věcí než začneme"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Set up permissions
		pscope.addPermission(ContactsPermission(),
			message: "Kouknem se kolik máš kamarádů")
		pscope.addPermission(LocationWhileInUsePermission(),
			message: "Uvidíme kde jsi")

		// Show dialog with callbacks
		pscope.show({ finished, results in
			print("got results \(results)")
			}, cancelled: { (results) -> Void in
			print("thing was cancelled")
		})

		gyroscope.startMotionCollection()

		self.sendButton.addTarget(self, action: #selector(sendForm(_:)), forControlEvents: .TouchUpInside)

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
		view.addGestureRecognizer(tapGesture)

	}

	override func viewDidAppear(animated: Bool) {
		mainTimer = Timer(name: "MainForm")
		mainTimer!.start()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	private func createStackHorizontalLine(name: String) -> UIStackView {

		let txt = TwistoInput()
		txt.delegate = self
		txt.designer()
		txt.placeholder = name
		allTextFields[name] = txt
		copyAndPaseInformations[name] = false

		let stackView = UIStackView(arrangedSubviews: [txt])
		stackView.axis = .Horizontal
		stackView.spacing = 10

		txt.snp_makeConstraints { (make) in
			make.height.equalTo(40)
		}

		return stackView
	}

	func sendForm(sender: UIButton) {

		mainTimer!.stop()
		Collector.Instance().totalTime = mainTimer?.count

		UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
		Collector.Instance().orientation = UIDevice.currentDevice().orientation
		UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()

		if areInputsFilled() {
			let progressController = ProgressController()
			progressController.name = allTextFields["Jmeno"]!.text
			progressController.address = allTextFields["Adresa"]!.text
			progressController.city = allTextFields["Mesto"]!.text
			progressController.zip = allTextFields["PSČ"]!.text
			progressController.phone = allTextFields["Tel"]!.text
			progressController.price = allTextFields["Pujcka"]!.text
			progressController.mail = allTextFields["Mail"]!.text
			self.navigationController?.pushViewController(progressController, animated: true)
		}

	}

	func areInputsFilled() -> Bool {
		var result = true
		for (key, textfield) in allTextFields {
			if textfield.text!.isEmpty {
				textfield.layer.borderColor = UIColor.redColor().CGColor
				result = false
			} else {
				textfield.layer.borderColor = UIColor.grayColor().CGColor
			}
		}
		return result
	}

	func textFieldDidEndEditing(textField: UITextField) {

		let collector = Collector.Instance()
		collector.timer.getOrCreate(textField.placeholder!).stop()

		collector.gyroscope.startGyroCollection()
		if let gyroscopeData = collector.gyroscope.getAverageGyroData() {
			collector.gyroData.append(gyroscopeData)
		}

		if textField.isEqual(allTextFields["PSČ"]) {
			self.view.frame.origin.y += 85
		} else if textField.isEqual(allTextFields["Tel"]) {
			self.view.frame.origin.y += 140
		} else if textField.isEqual(allTextFields["Mail"]) {
			self.view.frame.origin.y += 180
		} else if textField.isEqual(allTextFields["Pujcka"]) {
			self.view.frame.origin.y += 210
		}
	}

	func textFieldDidBeginEditing(textField: UITextField) {
		print(textField.placeholder!)
		Collector.Instance().gyroscope.startGyroCollection()
		Collector.Instance().timer.getOrCreate(textField.placeholder!).start()

		if textField.isEqual(allTextFields["PSČ"]) {
			self.view.frame.origin.y -= 85
		} else if textField.isEqual(allTextFields["Tel"]) {
			self.view.frame.origin.y -= 140
		} else if textField.isEqual(allTextFields["Mail"]) {
			self.view.frame.origin.y -= 180
		} else if textField.isEqual(allTextFields["Pujcka"]) {
			self.view.frame.origin.y -= 210
		}
	}

	// for diasble editing of textField when clicked somewhere else
	func tap(gesture: UITapGestureRecognizer) {
		allTextFields.forEach({ key, textField in
			textField.resignFirstResponder()
		})
	}

	func cutDouble(value: Double) -> String {
		return String(format: "%.3f", value)
	}

	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		// Here we check if the replacement text is equal to the string we are currently holding in the paste board
		if (UIPasteboard.generalPasteboard().string == string) {
			let fieldLabel = textField.superview?.subviews.first as! TwistoInput
			copyAndPaseInformations[fieldLabel.placeholder!] = true
		}

		return true;
	}

}
