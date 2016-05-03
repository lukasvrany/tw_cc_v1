//
//  RulesGeneral.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 02.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit

class RulesGeneral {

	var allRules = [(String, Int)]()

	init() {
		let deviceInfo = DeviceInfo()
		allRules.append(getRuleModel(deviceInfo.getModel()))
		allRules.append(getRuleDeviceName(deviceInfo.getDeviceName()))
		allRules.append(getRuleiOsVersion(deviceInfo.getiOsVersion()))
		allRules.append(getRuleBatteryValue(deviceInfo.getBatteryValue()))
		allRules.append(getRuleBatteryState(deviceInfo.getBatteryState()))
		allRules.append(getRuleSSID(deviceInfo.getSSID()))
		allRules.append(getRuleBSSID(deviceInfo.getBSSID()))
		allRules.append(getRuleConnectType(deviceInfo.getConnectType()))
		allRules.append(getRuleCellularProvider(deviceInfo.getCellularProvider()))
		allRules.append(getRuleAppleWatch(deviceInfo.getAppleWatch()))
	}

	func getRuleModel(model: String) -> (text: String, coef: Int) {

		switch (model) {
		case "iPhone 6s Plus", "iPhone 6s":
			return (model + " je celkem drahý mobil. Proč si potřebuješ půjčovat?", -3)
		case "Simulator":
			return (model + " je ok", 256)
		default:
			return (model, 0)
		}
	}

	func getRuleDeviceName(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleiOsVersion(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleBatteryValue(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleBatteryState(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleSSID(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleBSSID(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleConnectType(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleCellularProvider(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getRuleAppleWatch(input: String) -> (text: String, coef: Int) {
		return (input, 0)
	}

	func getAllRules(ignoreZero: Bool = true) -> [(String, Int)] {

		if ignoreZero {
			let filteredRules = allRules.filter({
				$0.1 != 0
			})
			return filteredRules
		} else {
			return allRules
		}
	}
}
