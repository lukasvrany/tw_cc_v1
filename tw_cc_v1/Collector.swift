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
import SwiftyJSON

struct behaviour {
	var destricption: String
	var coeficient: Int

	var image: UIImage {
		get {
			return (coeficient > 0 ? UIImage(named: "positive") : UIImage(named: "negative"))!
		}
	}

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

	var validResponseFromNikita: Bool?
	var response_info: JSON?

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

	func isFast(limit: Double) -> Bool {
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
		behaviourByNikita()
	}

	func behaviourByNikita() {
		if !validResponseFromNikita! || response_info!["status"].string != "accepted" {
			addBehaviour("Nedomluvili jsme se s Nikitou", coef: -5)
			return
		}

		behaviourScore()
		behaviourRating()
		behaviourFlags()

	}

	func behaviourScore() {
		switch (response_info!["score"].int!) {
		case 0..<350:
			addBehaviour("", coef: 5)
		case 350..<500:
			addBehaviour("Podle Nikite je OK", coef: 5)
		case 500..<1000:
			addBehaviour("Nikita: Klidně mu můžes půjčit", coef: 5)
		default:
			addBehaviour("Nikita: Klidně mu můžes půjčit", coef: 5)
		}
	}

	func behaviourRating() {
		guard response_info!["rating"].string != nil else {
			addBehaviour("Neznámý rating", coef: -5)
			return
		}

		switch (response_info!["rating"].string!) {
		case "A":
			addBehaviour("Podle Nikity má rating A", coef: 5)
		case "B":
			addBehaviour("Podle Nikity má rating B", coef: 5)
		case "C":
			addBehaviour("Podle Nikity má rating C", coef: 5)
		case "D":
			addBehaviour("Podle Nikity má rating D", coef: 5)
		case "E":
			addBehaviour("Podle Nikity má rating E", coef: 5)
		case "N":
			addBehaviour("Podle Nikity má rating N", coef: 5)
		case "0":
			addBehaviour("Podle Nikity má rating 0", coef: 5)
		default:
			addBehaviour("Neznamý rating", coef: -5)
		}
	}

	func behaviourFlags() {
		guard response_info!["flags"] != nil else {
			return
		}

		var flags = response_info!["flags"]

		if flags["justicy"].bool == true {
			addBehaviour("Má záznam v registru dlužníků", coef: -20)
		} else {
			addBehaviour("Nemá záznamu v registru dlužníků", coef: 5)
		}

		if flags["invalid_address"].bool == true {
			addBehaviour("Zadal neexistující adresu. Dobrej pokus", coef: -5)
		} else {
			addBehaviour("Zadal existující adresu", coef: 5)
		}

		if flags["tor"].bool == true {
			addBehaviour("Použil anonymní proxy", coef: -5)
		} else {

		}

		if flags["request"].bool == true {
			addBehaviour("Odeslal falešný request Nikitě", coef: -5)
		} else {

		}

	}

	func behaviourBySpeed() {

		if isFast(2) {
			addBehaviour("Takhle rychle formulář nemohl vyplnit", coef: -15)
		} else if isFast(15) {
			addBehaviour("Umí pěkně ryhle psát", coef: 1)
		}

		if isSlow() {
			addBehaviour("Píše pěkně pomalu", coef: -2)
			addBehaviour("Asi neví svojí adresu", coef: -3)
		}

	}

	func behaviourByGyroscope() {
		if isNervous() {
			addBehaviour("Je nervózní", coef: -7)
		}
	}

	func behaviourBySpeedAndGyroscope() {
		if hasAlzheimer() {
			addBehaviour("Má alzheimera", coef: -5)
		}
	}

	func behaviourByPhoneModel() {

		switch device.getModel() {
		case "iPod Touch 5", "iPod Touch 6":
			addBehaviour("Je muzikofil", coef: 2)
		case "iPhone 4", "iPhone 4s", "iPhone 5", "iPad 2":
			addBehaviour("Je chudý", coef: -5)
		case "iPhone 5c":
			addBehaviour("Je veselý", coef: 2)
		case "iPhone 5s": break
		case "iPhone 6": break
		case "iPhone 6 Plus":
			addBehaviour("Má velké ruce", coef: 1)
		case "iPhone 6s":
			addBehaviour("Je bohatý", coef: 8)
		case "iPhone 6s Plus":
			addBehaviour("Je bohatý", coef: 10)
			addBehaviour("Má velké ruce", coef: 1)
		case "iPhone SE":
			addBehaviour("Má malé ruce", coef: 1)
		case "iPad 3": break
		case "iPad 4": break
		case "iPad Air": break
		case "iPad Air 2": break
		case "iPad Mini": break
		case "iPad Mini 2": break
		case "iPad Mini 3": break
		case "iPad Mini 4": break
		case "iPad Pro":
			addBehaviour("Je hodně bohatý", coef: 15)
		case "Apple TV": break;
		case "Simulator": break
		default: break
		}
	}

	func behaviourByiOsVersion() {

		if device.getiOsVersion().rangeOfString("9.") == nil {
			addBehaviour("Je nezodpovědný", coef: -5)
			addBehaviour("Je líný", coef: -5)
		}
	}

	func behaviourByBattery() {
		if Double(device.getBatteryValue()) < 15 {
			addBehaviour("Má vybitej mobil, je to prostě hovado, který má opravdu hodně moc vybitý telefon", coef: -3)
		}
	}
    
    func behaviourByDeviceMotion(){
        if let motionResults = gyroscope.getAverageMotionData() {
            if motionResults.roll > 1.5 {
                addBehaviour("Málem usnul", coef: -5)
            }
        }
    }

	func behaviourByCellular() {
		let site = device.getCellularProvider()
		if site.rangeOfString("O2") != nil {
			addBehaviour("Má O2, nic moc", coef: 1)
		} else if site.rangeOfString("VF") != nil {
			addBehaviour("Má Vodafone, nic moc", coef: 1)
		} else if site.rangeOfString("TM") != nil {
			addBehaviour("Má T-Mobile, nic moc", coef: 1)
		}
	}

	func behaviourByAppleWatch() {
		if device.getAppleWatch() {
			addBehaviour("Má style", coef: 4)
			addBehaviour("Rád utrácí za zbytečnosti", coef: -6)
		} else {
			addBehaviour("Neutrácí za zbytečnosti", coef: 2)
		}
	}

	private func addBehaviour(desc: String, coef: Int) {
		behaviours.append(behaviour(desc: desc, coef: coef))
	}

	func getBehaviourCount() -> Int {
		return behaviours.count
	}

}