//
//  ScrollTrial.swift
//  MyTouch
//
//  Created by Tommy Lin on 2018/7/19.
//  Copyright © 2018年 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

class ScrollTrial: Trial {
    
    var isHorizontal = false
    
    var initialOffset = CGPoint.zero
    var targetOffsetUpperBound = CGPoint.zero
    var targetOffsetLowerBound = CGPoint.zero
    var endDraggingOffset = CGPoint.zero
    var endScrollingOffset = CGPoint.zero

    var coreMotionAccelerometer = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionGyroscope = CMRotationRate(x: 0, y: 0, z: 0)
    var coreMotionDeviceMotion = CMAcceleration(x: 0, y: 0, z: 0)
    var coreMotionActivity = CMMotionActivity()
    
    override init(trial: ORKTouchAbilityTrial) {
        super.init(trial: trial)
        if let trial = trial as? ORKTouchAbilityScrollTrial {
            self.isHorizontal = trial.direction == .horizontal
            self.initialOffset = trial.initialOffset
            self.targetOffsetUpperBound = trial.targetOffsetUpperBound
            self.targetOffsetLowerBound = trial.targetOffsetLowerBound
            self.endDraggingOffset = trial.endDraggingOffset
            self.endScrollingOffset = trial.endScrollingOffset

            //SYENNY-NOTE: Add accelerometer and gyroscope
            self.coreMotionAccelerometer = trial.coreMotionAccelerometer
            self.coreMotionGyroscope =  trial.coreMotionGyroscope
            self.coreMotionDeviceMotion = trial.coreMotionDeviceMotion
            trial.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (activity) in
                guard let activity = activity else { return }

                self?.coreMotionActivity = activity
            }
            NSLog("Acceleration in ScrollTrial, x: %f y: %f z: %f", self.coreMotionAccelerometer.x, self.coreMotionAccelerometer.y, self.coreMotionAccelerometer.z)
            NSLog("Gyroscope in ScrollTrial, x: %f y: %f z: %f", self.coreMotionGyroscope.x, self.coreMotionGyroscope.y, self.coreMotionGyroscope.z)
            NSLog("Device Motion in ScrollTrial, x: %f y: %f z: %f", self.coreMotionDeviceMotion.x, self.coreMotionDeviceMotion.y, self.coreMotionDeviceMotion.z)
        }
    }
    
    /*required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }*/
    enum StructKeysA: String, CodingKey {
        case isHorizontal,initialOffset,targetOffsetUpperBound,targetOffsetLowerBound,endDraggingOffset,endScrollingOffset
    }
    override func encode(to encoder: Encoder) throws {
        
        var container =  encoder.container(keyedBy: StructKeysA.self)
        try container.encode(isHorizontal, forKey: .isHorizontal)
        try container.encode(initialOffset, forKey: .initialOffset)
        try container.encode(targetOffsetUpperBound, forKey: .targetOffsetUpperBound)
        try container.encode(targetOffsetLowerBound, forKey: .targetOffsetLowerBound)
        try container.encode(endDraggingOffset, forKey: .endDraggingOffset)
        try container.encode(endScrollingOffset, forKey: .endScrollingOffset)
        try super.encode(to: encoder)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StructKeysA.self)
        self.isHorizontal = try container.decode(Bool.self, forKey: .isHorizontal)
        self.initialOffset = try container.decode(CGPoint.self, forKey: .initialOffset)
        self.targetOffsetUpperBound = try container.decode(CGPoint.self, forKey: .targetOffsetUpperBound)
        self.targetOffsetLowerBound = try container.decode(CGPoint.self, forKey: .targetOffsetLowerBound)
        self.endDraggingOffset = try container.decode(CGPoint.self, forKey: .endDraggingOffset)
        self.endScrollingOffset = try container.decode(CGPoint.self, forKey: .endScrollingOffset)
        try super.init(from: decoder)
    }
}
