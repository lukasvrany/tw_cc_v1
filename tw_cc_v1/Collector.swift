//
//  File.swift
//  tw_cc_v1
//
//  Created by EN on 11.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

struct behaviour {
	var destricption: String
	var coeficient: Int

	init(desc: String, coef: Int) {
		self.destricption = desc
		self.coeficient = coef
	}

}

class Collector {

	private static let instance: Collector = Collector()

	let gyroscope = Gyroscope()
	let device = DeviceInfo()
	let healthkit = HealKitData()
	let timer = TimersManager()

	var gyroData = [CMRotationRate]()

	var positive = [behaviour]()
	var negative = [behaviour]()

	private init() { }

	static func Instance() -> Collector {
		return instance
	}

	func isNervous() -> Bool {
		print(gyroData)
		let x: Double = gyroData.reduce(0, combine: { $0 + abs($1.x) }) / Double(gyroData.count)
		let y: Double = gyroData.reduce(0, combine: { $0 + abs($1.y) }) / Double(gyroData.count)
		let z: Double = gyroData.reduce(0, combine: { $0 + abs($1.z) }) / Double(gyroData.count)

		return x > 0.25 || y > 0.25 || z > 0.25
	}

	func isRich() -> Bool {
		switch (device.getModel()) {
		case "iPhone 6s Plus", "iPhone 6s":
			return true
		default:
			return false
		}
	}

	func hasLowBattery() -> Bool {
		return Double(device.getBatteryValue()) < 15
	}

	func isSlow() -> Bool {
		let total = timer.namelessTimers.reduce(0, combine: { $0 + $1.count }) / Double(timer.namelessTimers.count)
		return total > 60
	}

	func isFast() -> Bool {
		let total = timer.namelessTimers.reduce(0, combine: { $0 + $1.count }) / Double(timer.namelessTimers.count)
		return total > 20
	}

	func hasAlzheimer() -> Bool {
		return isSlow() && isNervous()
	}

	func evaluation() -> String {
		print()
		let noun = getNoun()
		let adjective = getAdjective()
		let anotherExtra = getAnotherExtra()
		let extra = getExtra()

		let set = NSCharacterSet(charactersInString: " .")

		return "\(adjective) \(noun) \(extra) \(anotherExtra)".stringByTrimmingCharactersInSet(set)
	}

	func getNoun() -> String {
		return isFast() ? "speedster" : (isSlow() ? "grandma" : "man")
	}

	func getAdjective() -> String {
		return isRich() ? "wealthy" : "pink-collar"
	}

	func getAnotherExtra() -> String {
		return hasLowBattery() ? "who's got almost no battery" : ""
	}

	func getExtra() -> String {
		return hasAlzheimer() ? "with alzheimer" : ""
	}

	// Nove rozhrani

	func behaviourByPhoneModel() {

		switch device.getModel() {
		case "iPod Touch 5", "iPod Touch 6":
			positive.append(behaviour(desc: "Jsi muzikofil", coef: 2))
		case "iPhone 4", "iPhone 4s", "iPhone 5", "iPad 2":
			negative.append(behaviour(desc: "Jsi chudý", coef: -5))
		case "iPhone 5c":
			positive.append(behaviour(desc: "Jsi veselý", coef: 2))
		case "iPhone 5s": break
		case "iPhone 6": break
		case "iPhone 6 Plus":
			positive.append(behaviour(desc: "Máš velké ruce", coef: 1))
		case "iPhone 6s":
			positive.append(behaviour(desc: "Jsi bohatý", coef: 8))
		case "iPhone 6s Plus":
			positive.append(behaviour(desc: "Jsi bohatý", coef: 10))
			positive.append(behaviour(desc: "Máš velké ruce", coef: 1))
		case "iPhone SE":
			positive.append(behaviour(desc: "Máš malé ruce", coef: 1))
		case "iPad 3": break
		case "iPad 4": break
		case "iPad Air": break
		case "iPad Air 2": break
		case "iPad Mini": break
		case "iPad Mini 2": break
		case "iPad Mini 3": break
		case "iPad Mini 4": break
		case "iPad Pro":
			positive.append(behaviour(desc: "Jsi hodně bohatý", coef: 15))
		case "Apple TV": break;
		case "Simulator": break
		default: break
		}
	}

	func behaviourByiOsVersion() {

		if device.getiOsVersion().rangeOfString("9.") == nil {
			negative.append(behaviour(desc: "Jdi nezodpovědný", coef: 5))
			negative.append(behaviour(desc: "Jdi líný", coef: 5))
		}
	}

	func behaviourByBattery() {
		if Double(device.getBatteryValue()) < 15 {
			negative.append(behaviour(desc: "Náš vybitej mobil", coef: 3))
		}
	}

	func behaviourByCellular() {
		if device.getCellularProvider().rangeOfString("O2") != nil {
			negative.append(behaviour(desc: "O2 nic moc ", coef: 1))
		} else if device.getCellularProvider().rangeOfString("Vodafone") != nil {
			negative.append(behaviour(desc: "Vodafone nic moc ", coef: 1))
		} else if device.getCellularProvider().rangeOfString("T-Mobile") != nil {
			negative.append(behaviour(desc: "T-Mobile nic moc ", coef: 1))
		}
	}

	func behaviourByAppleWatch() {
		if device.getAppleWatch() {
			positive.append(behaviour(desc: "Máš style", coef: 4))
			negative.append(behaviour(desc: "Rád utrácíš za zbytečnosti", coef: 6))
		}
	}

}