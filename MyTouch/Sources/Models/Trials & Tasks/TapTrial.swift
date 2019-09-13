//
//  TapTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/6/29.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class TapTrial: Trial {
    
    var targetFrame = CGRect.zero
    var success = false
    var coreMotionAccelerometer = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionGyroscope = CMRotationRate(x: 0, y: 0, z: 0)
    var coreMotionDeviceMotion = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionActivity = CMMotionActivity()

    enum StructKeysA: String, CodingKey {
        case targetFrame,success
    }
    override init(trial: ORKTouchAbilityTrial) {
        //print("hehe",self.targetFrame)
        //self.targetFrame = CGRect.zero
        //self.success = false
        super.init(trial: trial)

        if let trial = trial as? ORKTouchAbilityTapTrial {
            self.targetFrame = trial.targetFrameInWindow
            self.success = trial.success
    
            //SYENNY-NOTE: Add accelerometer and gyroscope
            self.coreMotionAccelerometer = trial.coreMotionAccelerometer
            self.coreMotionGyroscope =  trial.coreMotionGyroscope
            self.coreMotionDeviceMotion = trial.coreMotionDeviceMotion
            trial.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (activity) in
                guard let activity = activity else { return }

                self?.coreMotionActivity = activity
            }
            NSLog("Acceleration in TapTrial, x: %f y: %f z: %f", self.coreMotionAccelerometer.x, self.coreMotionAccelerometer.y, self.coreMotionAccelerometer.z)
            NSLog("Gyroscope in TapTrial, x: %f y: %f z: %f", self.coreMotionGyroscope.x, self.coreMotionGyroscope.y, self.coreMotionGyroscope.z)
            NSLog("Device Motion in TapTrial, x: %f y: %f z: %f", self.coreMotionDeviceMotion.x, self.coreMotionDeviceMotion.y, self.coreMotionDeviceMotion.z)
            //print(self.targetFrame)
        }
    }
    override func encode(to encoder: Encoder) throws {
        
        var container =  encoder.container(keyedBy: StructKeysA.self)
        try container.encode(targetFrame, forKey: .targetFrame)
        try container.encode(success, forKey: .success)
        try super.encode(to: encoder)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StructKeysA.self)
        self.targetFrame = try container.decode(CGRect.self, forKey: .targetFrame)
        self.success = try container.decode(Bool.self, forKey: .success)
        try super.init(from: decoder)
    }
    
}