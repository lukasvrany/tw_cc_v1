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
	var info: [String: String]

	init() {
		device = UIDevice.currentDevice()
		info = [:]
	}

	func getAllInformation() -> [String: String] {

		info["model"] = device.modelName
		info["deviceName"] = device.name
		info["ios"] = device.systemVersion

		let batteryInfo = getBatteryInfo()
		info["batteryValue"] = batteryInfo.value
		info["batteryState"] = batteryInfo.state

		let wifiInfo = device.wifi
		info["SSID"] = wifiInfo.SSID
		info["BSSID"] = wifiInfo.BSSID

		info["connectType"] = device.connectivity
		info["cellularProvider"] = device.cellularProvider

		info["appleWatch"] = device.connectedAppleWatch

		return info
	}

	private func getBatteryInfo() -> (value: String, state: String) {
		device.batteryMonitoringEnabled = true
		let value = device.batteryLevel
		let state = device.batteryState
		device.batteryMonitoringEnabled = false
		return (String(value * 100), batteryStateMapping(state))
	}
    
    private func batteryStateMapping(state:UIDeviceBatteryState)->String{
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