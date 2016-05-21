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

	var behaviours = [behaviour]()

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

	func isSlow() -> Bool {
		let total = timer.namelessTimers.reduce(0, combine: { $0 + $1.count }) / Double(timer.namelessTimers.count)
		return total > 60
	}

	func isFast(limit: Double = 20) -> Bool {
		let total = timer.namelessTimers.reduce(0, combine: { $0 + $1.count }) / Double(timer.namelessTimers.count)
		return total < limit
	}

	func hasAlzheimer() -> Bool {
		return isSlow() && isNervous()
	}

	func clearBehaviour() {
		behaviours.removeAll()
	}

	func calculateBehaviour() {
		clearBehaviour()
		behaviourBySpeed()
		behaviourByBattery()
		behaviourByCellular()
		behaviourByGyroscope()
		behaviourByAppleWatch()
		behaviourByiOsVersion()
		behaviourByPhoneModel()
	}

	func behaviourBySpeed() {
		if isFast() {
			addBehaviour("Jseš rychlej", coef: 1)
		}

		if isSlow() {
			addBehaviour("Jseš pomalej", coef: -2)
			addBehaviour("Nevíš kde bydlíš", coef: -3)
		}

		if isFast(5) {
			addBehaviour("Jdeš ryhlej a podezřelej", coef: -5)
		}

		if isFast(1) {
			addBehaviour("Podvádíš", coef: -15)
		}
	}

	func behaviourByGyroscope() {
		if isNervous() {
			addBehaviour("Jsi nervózní", coef: -7)
		}
	}

	func behaviourBySpeedAndGyroscope() {
		if hasAlzheimer() {
			addBehaviour("Máš alzheimera", coef: -5)
		}
	}

	func behaviourByPhoneModel() {

		switch device.getModel() {
		case "iPod Touch 5", "iPod Touch 6":
			addBehaviour("Jsi muzikofil", coef: 2)
		case "iPhone 4", "iPhone 4s", "iPhone 5", "iPad 2":
			addBehaviour("Jsi chudý", coef: -5)
		case "iPhone 5c":
			addBehaviour("Jsi veselý", coef: 2)
		case "iPhone 5s": break
		case "iPhone 6": break
		case "iPhone 6 Plus":
			addBehaviour("Máš velké ruce", coef: 1)
		case "iPhone 6s":
			addBehaviour("Jsi bohatý", coef: 8)
		case "iPhone 6s Plus":
			addBehaviour("Jsi bohatý", coef: 10)
			addBehaviour("Máš velké ruce", coef: 1)
		case "iPhone SE":
			addBehaviour("Máš malé ruce", coef: 1)
		case "iPad 3": break
		case "iPad 4": break
		case "iPad Air": break
		case "iPad Air 2": break
		case "iPad Mini": break
		case "iPad Mini 2": break
		case "iPad Mini 3": break
		case "iPad Mini 4": break
		case "iPad Pro":
			addBehaviour("Jsi hodně bohatý", coef: 15)
		case "Apple TV": break;
		case "Simulator": break
		default: break
		}
	}

	func behaviourByiOsVersion() {

		if device.getiOsVersion().rangeOfString("9.") == nil {
			addBehaviour("Jsi nezodpovědný", coef: -5)
			addBehaviour("Jsi líný", coef: -5)
		}
	}

	func behaviourByBattery() {
		if Double(device.getBatteryValue()) < 15 {
			addBehaviour("Náš vybitej mobil", coef: -3)
		}
	}

	func behaviourByCellular() {
		let site = device.getCellularProvider()
		if site.rangeOfString("O2") != nil {
			addBehaviour("O2 nic moc", coef: 1)
		} else if site.rangeOfString("VF") != nil {
			addBehaviour("Vodafone nic moc", coef: 1)
		} else if site.rangeOfString("TM") != nil {
			addBehaviour("T-Mobile nic moc", coef: 1)
		}
	}

	func behaviourByAppleWatch() {
		if device.getAppleWatch() {
			addBehaviour("Máš style", coef: 4)
			addBehaviour("Rád utrácíš za zbytečnosti", coef: -6)
		} else {
			addBehaviour("Neutrácíš za zbytečnosti", coef: 2)
		}
	}

	private func addBehaviour(desc: String, coef: Int) {
		behaviours.append(behaviour(desc: desc, coef: coef))
	}

	func getBehaviourCount() -> Int {
		return behaviours.count
	}

}