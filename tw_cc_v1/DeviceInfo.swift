//
//  DeviceInfo.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 19.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit

class DeviceInfo {

	var device: UIDevice

	init() {
		device = UIDevice.currentDevice()
	}

	func getModel() -> String {
		return device.modelName
	}

	func getDeviceName() -> String {
		return device.name
	}

	func getiOsVersion() -> String {
		return device.systemVersion
	}

	func getBatteryValue() -> String {
		let batteryInfo = getBatteryInfo()
		return batteryInfo.value
	}

	func getBatteryState() -> String {
		let batteryInfo = getBatteryInfo()
		return batteryInfo.state
	}

	func getSSID() -> String {
		let wifiInfo = device.wifi
		return wifiInfo.SSID
	}

	func getBSSID() -> String {
		let wifiInfo = device.wifi
		return wifiInfo.BSSID
	}

	func getConnectType() -> String {
		return device.connectivity
	}

	func getCellularProvider() -> String {
		return device.cellularProvider
	}

	func getAppleWatch() -> Bool {
		return device.isConnectedAppleWatch
	}

	private func getBatteryInfo() -> (value: String, state: String) {
		device.batteryMonitoringEnabled = true
		let value = device.batteryLevel
		let state = device.batteryState
		device.batteryMonitoringEnabled = false
		return (String(value * 100), batteryStateMapping(state))
	}

	private func batteryStateMapping(state: UIDeviceBatteryState) -> String {
		switch state {
		case .Charging:
			return "Charging"
		case .Full:
			return "Full"
		case .Unplugged:
			return "Unplugged"
		default:
			return "Unknow"
		}
	}
}