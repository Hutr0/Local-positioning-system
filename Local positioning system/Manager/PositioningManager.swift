//
//  Positioning Manager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

class PositioningManager {
    
    let positioningMotionManager = PositioningMotionManager()
    
    var motionData: [MotionData] = []
    
    func startRecordingMotions() {
        positioningMotionManager.startDeviceMotionUpdate { rotationRate, attitude, userAcceleration, gravity in
            
            self.motionData.append(MotionData(rotationRate: rotationRate,
                                              attitude: attitude,
                                              userAcceleration: userAcceleration,
                                              gravity: gravity))
        }
    }
}
