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
    
    enum GeneralInfo {
        case Model
        case DeviceName
        case VersioniOs
        case BatterryValue
        case BaterryState
        case SSID
        case BSSID
        case ConnectType
        case CellularProvider
        case AppleWatchConnect
    }

	static let sharedInstance = RulesGeneral()

    var data = [GeneralInfo: String]()

	private init() {
        let deviceInfo = DeviceInfo()
        data[.Model] = deviceInfo.getModel()
        data[.DeviceName] = deviceInfo.getDeviceName()
        data[.VersioniOs] = deviceInfo.getiOsVersion()
        data[.BatterryValue] = deviceInfo.getBatteryValue()
        data[.BaterryState] = deviceInfo.getBatteryState()
        data[.SSID] = deviceInfo.getSSID()
        data[.BSSID] = deviceInfo.getBSSID()
        data[.ConnectType] = deviceInfo.getConnectType()
        data[.CellularProvider] = deviceInfo.getCellularProvider()
        data[.AppleWatchConnect] = deviceInfo.getAppleWatch()
    }
    
    func getRuleModel() -> (value: String, text: String, coef: Double){
        if data[.Model] == "iPhone 6s Plus"{
            return (data[.Model]!, "Celkem drahý mobil. Proč si chceš půjčovat?",-3)
        }
        
        return ("Nevím", "Nic", 0)
    }
    
}
