//
//  PinchTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class PinchTrial: Trial {
    
    var targetScale: CGFloat = 1.0
    var resultScale: CGFloat = 1.0

    var coreMotionAccelerometer = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionGyroscope = CMRotationRate(x: 0, y: 0, z: 0)
    var coreMotionDeviceMotion = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionActivity = CMMotionActivity()
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilityPinchTrial {
            self.targetScale = trial.targetScale
            self.resultScale = trial.resultScale

            //SYENNY-NOTE: Add accelerometer and gyroscope
            self.coreMotionAccelerometer = trial.coreMotionAccelerometer
            self.coreMotionGyroscope =  trial.coreMotionGyroscope
            self.coreMotionDeviceMotion = trial.coreMotionDeviceMotion
            trial.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (activity) in
                guard let activity = activity else { return }

                self?.coreMotionActivity = activity
            }
            NSLog("Acceleration in PinchTrial, x: %f y: %f z: %f", self.coreMotionAccelerometer.x, self.coreMotionAccelerometer.y, self.coreMotionAccelerometer.z)
            NSLog("Gyroscope in PinchTrial, x: %f y: %f z: %f", self.coreMotionGyroscope.x, self.coreMotionGyroscope.y, self.coreMotionGyroscope.z)
            NSLog("Device Motion in PinchTrial, x: %f y: %f z: %f", self.coreMotionDeviceMotion.x, self.coreMotionDeviceMotion.y, self.coreMotionDeviceMotion.z)
        }
    }
    
    /*required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }*/
    enum StructKeysA: String, CodingKey {
        case targetScale,resultScale
    }
    override func encode(to encoder: Encoder) throws {
        
        var container =  encoder.container(keyedBy: StructKeysA.self)
        try container.encode(targetScale, forKey: .targetScale)
        try container.encode(resultScale, forKey: .resultScale)
        try super.encode(to: encoder)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StructKeysA.self)
        self.targetScale = try container.decode(CGFloat.self, forKey: .targetScale)
        self.resultScale = try container.decode(CGFloat.self, forKey: .resultScale)
        try super.init(from: decoder)
    }
}
