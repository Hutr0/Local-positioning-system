//
//  Positioning Manager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation
import CoreMotion

class PositioningManager {
    
    let motionManager = CMMotionManager()
    
    func startDeviceMotionUpdateWith(completionHandler: @escaping (CMDeviceMotion) -> ()) {
        motionManager.deviceMotionUpdateInterval = 0.5
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { motion, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let motion = motion else { return }
            completionHandler(motion)
        }
    }
}
