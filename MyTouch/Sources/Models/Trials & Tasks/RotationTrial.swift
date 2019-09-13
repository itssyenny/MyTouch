//
//  RotationTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/20.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class RotationTrial: Trial {
    
    var targetRotation: CGFloat = 0.0
    var resultRotation: CGFloat = 0.0

    var coreMotionAccelerometer = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionGyroscope = CMRotationRate(x: 0, y: 0, z: 0)
    var coreMotionDeviceMotion = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionActivity = CMMotionActivity()
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilityRotationTrial {
            self.targetRotation = trial.targetRotation
            self.resultRotation = trial.resultRotation

            //SYENNY-NOTE: Add accelerometer and gyroscope
            self.coreMotionAccelerometer = trial.coreMotionAccelerometer
            self.coreMotionGyroscope =  trial.coreMotionGyroscope
            self.coreMotionDeviceMotion = trial.coreMotionDeviceMotion
            trial.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (activity) in
                guard let activity = activity else { return }

                self?.coreMotionActivity = activity
            }
            NSLog("Acceleration in RotationTrial: x: %f y: %f z: %f", self.coreMotionAccelerometer.x, self.coreMotionAccelerometer.y, self.coreMotionAccelerometer.z)
            NSLog("Gyroscope in RotationTrial, x: %f y: %f z: %f", self.coreMotionGyroscope.x, self.coreMotionGyroscope.y, self.coreMotionGyroscope.z)
            NSLog("Device Motion in RotationTrial, x: %f y: %f z: %f", self.coreMotionDeviceMotion.x, self.coreMotionDeviceMotion.y, self.coreMotionDeviceMotion.z)
        }
    }
    
    /*required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }*/
    enum StructKeysA: String, CodingKey {
        case targetRotation,resultRotation
    }
    override func encode(to encoder: Encoder) throws {
        
        var container =  encoder.container(keyedBy: StructKeysA.self)
        try container.encode(targetRotation, forKey: .targetRotation)
        try container.encode(resultRotation, forKey: .resultRotation)
        try super.encode(to: encoder)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StructKeysA.self)
        self.targetRotation = try container.decode(CGFloat.self, forKey: .targetRotation)
        self.resultRotation = try container.decode(CGFloat.self, forKey: .resultRotation)

        try super.init(from: decoder)
    }
}
