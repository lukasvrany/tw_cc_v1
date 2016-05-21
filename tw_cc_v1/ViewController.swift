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

	let FORM_TIMER_NAME = "MainForm"

	// Pole vsech UITextField ve formalu.
	var allTextFields = [String: UITextField]()

	// Array obsahuje dalsi pole s ruznymi druhy informaci
	var allInformations = [String: [String: String]]()
	var motionInformations = [String: String]()
	var copyAndPaseInformations = [String: Bool]()

	var timers = TimersManager()

	weak var sendButton: UIButton!

	var gyroscope = Gyroscope()

	var healtkit = HealKitData()

	override func viewWillDisappear(animated: Bool) {
		gyroscope.pauseGyroCollection()
		gyroscope.pauseMotionCollection()
	}

	override func viewWillAppear(animated: Bool) {
		if gyroscope.gyroGathering {
			gyroscope.startGyroCollection()
		}

		if gyroscope.motionGathering {
			gyroscope.startMotionCollection()
		}
	}

	override func loadView() {
		super.loadView()

		self.view.backgroundColor = UIColor.whiteColor()
		self.title = "Registrace"

		let btnSend = UIButton()
		btnSend.setTitle("Send", forState: .Normal)
		btnSend.backgroundColor = UIColor.redColor()
		self.sendButton = btnSend

		let mainStackView = UIStackView(arrangedSubviews: [createStackHorizontalLine("Jmeno"),
			createStackHorizontalLine("Prijmeni"),
			createStackHorizontalLine("Adresa"),
			createStackHorizontalLine("Mesto"),
			createStackHorizontalLine("PSČ"),
			btnSend])

		mainStackView.axis = .Vertical
		mainStackView.spacing = 10
		self.view.addSubview(mainStackView)
		mainStackView.snp_makeConstraints { make in
			make.leading.equalTo(10)
			make.trailing.equalTo(-10)
			make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
		}

		let isHealkitAvailable = healtkit.healkitIsAvailable()
		if (isHealkitAvailable) {
			healtkit.authorizePermission()
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
		timers.resetAll()
		let mainTimer = timers.getOrCreate(FORM_TIMER_NAME)
		mainTimer.start()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	private func createStackHorizontalLine(name: String) -> UIStackView {
		let lbl = UILabel()
		lbl.text = name
		lbl.snp_makeConstraints { make in
			make.width.equalTo(80)
		}

		let txt = UITextField()
		txt.delegate = self
		txt.borderStyle = .RoundedRect
		allTextFields[name] = txt
		copyAndPaseInformations[name] = false

		let stackView = UIStackView(arrangedSubviews: [lbl, txt])
		stackView.axis = .Horizontal
		stackView.spacing = 10

		return stackView
	}

	func sendForm(sender: UIButton) {
		timers.getOrCreate(FORM_TIMER_NAME).stop()

		gyroscope.stopMotionCollection()
		if let motionResults = gyroscope.getAverageMotionData() {
			motionInformations["user position"] = (motionResults.roll > 1.5) ? "mostly lying" : "mostly standing"
		}

		self.navigationController?.pushViewController(ResultController(), animated: true)
	}

	func textFieldDidEndEditing(textField: UITextField) {
		let fieldLabel = textField.superview?.subviews.first as! UILabel

		let collector = Collector.Instance()
		collector.timer.getOrCreate(fieldLabel.text!).stop()

		collector.gyroscope.startGyroCollection()
		if let gyroscopeData = collector.gyroscope.getAverageGyroData() {
			collector.gyroData.append(gyroscopeData)
		}
	}

	func textFieldDidBeginEditing(textField: UITextField) {
		let fieldLabel = textField.superview?.subviews.first as! UILabel

		Collector.Instance().gyroscope.startGyroCollection()
		Collector.Instance().timer.getOrCreate(fieldLabel.text!).start()
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
			let fieldLabel = textField.superview?.subviews.first as! UILabel
			copyAndPaseInformations[fieldLabel.text!] = true
		}

		return true;
	}
}
