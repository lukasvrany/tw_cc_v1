//
//  Gyroscope.swift
//  gyroscope
//
//  Created by EN on 17.04.16.
//  Copyright © 2016 EN. All rights reserved.
//

import CoreMotion

struct Motion {
    var roll: Double
    var pitch: Double
    var yaw: Double
    
    init(roll: Double, pitch:Double, yaw:Double){
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
}


class Gyroscope {
    
    private let manager = CMMotionManager()
    private let queue = NSOperationQueue()
    
    private var lastGyroDataSet: Array<CMRotationRate>?
    private var lastMotionDataSet: Array<CMAttitude>?
    
    var gyroGathering = false
    var motionGathering = false
    
    var interval = 0.01 {
        didSet {
            manager.gyroUpdateInterval = interval
            manager.deviceMotionUpdateInterval = interval
        }
    }
    
    var gyroDataSet: Array<CMRotationRate>? { get { return lastGyroDataSet } }
    var motionDataSet: Array<CMAttitude>? { get { return lastMotionDataSet } }
    
    func startGyroCollection() {
        if manager.gyroAvailable {
            if !gyroGathering {
                gyroGathering = true
                lastGyroDataSet = Array()
            }
            manager.startGyroUpdatesToQueue(queue, withHandler: {
                gyroData, error in
                
                if let gyroData = gyroData{
                    self.lastGyroDataSet?.append(gyroData.rotationRate)
                }
            })
        }
    }
    
    func startMotionCollection() {
        if manager.deviceMotionAvailable {
            if !motionGathering {
                motionGathering = true
                lastMotionDataSet = Array()
            }
            manager.startDeviceMotionUpdatesToQueue(queue, withHandler: {
                motionData, error in
                
                if let motionData = motionData{
                    self.lastMotionDataSet?.append(motionData.attitude)
                }
            })
        }
    }
    
    func stopGyroCollection(){
        manager.stopGyroUpdates()
        gyroGathering = false
    }
    
    func stopMotionCollection(){
        manager.stopDeviceMotionUpdates()
        motionGathering = false
    }
    
    func pauseGyroCollection(){
        manager.stopGyroUpdates()
    }
    
    func pauseMotionCollection(){
        manager.stopDeviceMotionUpdates()
    }
    
    func getAverageGyroData() -> CMRotationRate? {
        if let lastGyroDataSet = self.lastGyroDataSet {
            let x:Double = lastGyroDataSet.reduce(0, combine: {$0 + abs($1.x)}) / Double(lastGyroDataSet.count)
            let y:Double = lastGyroDataSet.reduce(0, combine: {$0 + abs($1.y)}) / Double(lastGyroDataSet.count)
            let z:Double = lastGyroDataSet.reduce(0, combine: {$0 + abs($1.z)}) / Double(lastGyroDataSet.count)
            return CMRotationRate(x: x,y: y,z: z)
        } else {
            return nil
        }
    }
    
    func getAverageMotionData() -> Motion? {
        if let lastMotionDataSet = self.lastMotionDataSet {
            let yaw:Double = lastMotionDataSet.reduce(0, combine: {$0 + $1.yaw}) / Double(lastMotionDataSet.count)
            let roll:Double = lastMotionDataSet.reduce(0, combine: {$0 + abs($1.roll)}) / Double(lastMotionDataSet.count)
            let pitch:Double = lastMotionDataSet.reduce(0, combine: {$0 + $1.pitch}) / Double(lastMotionDataSet.count)
            return Motion(roll: roll, pitch: pitch, yaw: yaw)
        } else {
            return nil
        }
    }
    
    
}
