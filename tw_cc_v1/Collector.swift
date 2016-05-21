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

	func isSlow() -> Bool {
		let total = timer.namelessTimers.reduce(0, combine: { $0 + $1.count }) / Double(timer.namelessTimers.count)
		return total > 60
	}

    func isFast(limit:Double = 20) -> Bool {
		let total = timer.namelessTimers.reduce(0, combine: { $0 + $1.count }) / Double(timer.namelessTimers.count)
		return total > limit
	}

	func hasAlzheimer() -> Bool {
		return isSlow() && isNervous()
	}

    
    func behaviourBySpeed() {
        if isFast() {
            positive.append(behaviour(desc: "Jseš rychlej", coef: 1))
            addPositive("Jseš rychlej", coef: 1)
        }
        
        if isSlow() {
            addNegative("Jseš pomalej", coef: 2)
            addNegative("Nevíš kde bydlíš", coef: 3)
        }
        
        if isFast(5) {
            addNegative("Jdeš ryhlej a podezřelej", coef: 5)
        }
        
        if isFast(1) {
            addNegative("Podvádíš", coef: 15)
        }
    }
    
    func behaviourByGyroscope(){
        if isNervous() {
            addNegative("Jsi nervózní", coef: 7)
        }
    }
    
    func behaviourBySpeedAndGyroscope() {
        if hasAlzheimer() {
            addNegative("Máš alzheimera", coef: 5)
        }
    }

	func behaviourByPhoneModel() {

		switch device.getModel() {
		case "iPod Touch 5", "iPod Touch 6":
            addPositive("Jsi muzikofil", coef: 2)
		case "iPhone 4", "iPhone 4s", "iPhone 5", "iPad 2":
            addNegative("Jsi chudý", coef: 5)
		case "iPhone 5c":
            addPositive("Jsi veselý", coef: 2)
		case "iPhone 5s": break
		case "iPhone 6": break
		case "iPhone 6 Plus":
            addPositive("Máš velké ruce", coef: 1)
		case "iPhone 6s":
            addPositive("Jsi bohatý", coef: 8)
		case "iPhone 6s Plus":
            addPositive("Jsi bohatý", coef: 10)
            addPositive("Máš velké ruce", coef: 1)
		case "iPhone SE":
            addPositive("Máš malé ruce", coef: 1)
		case "iPad 3": break
		case "iPad 4": break
		case "iPad Air": break
		case "iPad Air 2": break
		case "iPad Mini": break
		case "iPad Mini 2": break
		case "iPad Mini 3": break
		case "iPad Mini 4": break
		case "iPad Pro":
            addPositive("Jsi hodně bohatý", coef: 15)
		case "Apple TV": break;
		case "Simulator": break
		default: break
		}
	}

	func behaviourByiOsVersion() {

		if device.getiOsVersion().rangeOfString("9.") == nil {
            addNegative("Jsi nezodpovědný", coef: 5)
            addNegative("Jsi líný", coef: 5)
		}
	}

	func behaviourByBattery() {
		if Double(device.getBatteryValue()) < 15 {
			negative.append(behaviour(desc: "Náš vybitej mobil", coef: 3))
            addNegative("Náš vybitej mobil", coef: 3)
		}
	}

	func behaviourByCellular() {
		if device.getCellularProvider().rangeOfString("O2") != nil {
			addNegative("O2 nic moc", coef: 1)
		} else if device.getCellularProvider().rangeOfString("Vodafone") != nil {
			addNegative("Vodafone nic moc", coef: 1)
		} else if device.getCellularProvider().rangeOfString("T-Mobile") != nil {
            addNegative("T-Mobile nic moc", coef: 1)
		}
	}

	func behaviourByAppleWatch() {
		if device.getAppleWatch() {
            addPositive("Máš style", coef: 4)
            addNegative("Rád utrácíš za zbytečnosti", coef: 6)
        } else {
            addPositive("Neutrácíš za zbytečnosti", coef: 2)
        }
	}
    
    private func addPositive(desc:String, coef:Int) {
        positive.append(behaviour(desc: desc, coef: coef))
    }
    
    private func addNegative(desc:String, coef:Int) {
        negative.append(behaviour(desc: desc, coef: coef))
    }

}