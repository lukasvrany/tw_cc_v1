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

class Collector{
    
    private static let instance : Collector = Collector()
    
    let gyroscope = Gyroscope()
    let device = DeviceInfo()
    let healthkit = HealKitData()
    let timer = TimersManager()
    
    var gyroData = [CMRotationRate]()
    
    private init() { }
    
    static func Instance() -> Collector {
        return instance
    }
    
    func isNervous() -> Bool{
        print(gyroData)
        let x:Double = gyroData.reduce(0, combine: {$0 + abs($1.x)}) / Double(gyroData.count)
        let y:Double = gyroData.reduce(0, combine: {$0 + abs($1.y)}) / Double(gyroData.count)
        let z:Double = gyroData.reduce(0, combine: {$0 + abs($1.z)}) / Double(gyroData.count)
        
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
        let total = timer.namelessTimers.reduce(0, combine: {$0 + $1.count})/Double(timer.namelessTimers.count)
        return total > 60
    }
    
    func isFast() -> Bool {
        let total = timer.namelessTimers.reduce(0, combine: {$0 + $1.count})/Double(timer.namelessTimers.count)
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
    
    func getNoun()->String{
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
}