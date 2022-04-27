//
//  PositioningMotionManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation
import CoreMotion

class PositioningMotionManager {
    
    let motionManager = CMMotionManager()
    
    init() {
        motionManager.deviceMotionUpdateInterval = 0.5
    }
    
    func startDeviceMotionUpdate(completionHandler: @escaping (RotationRate, Attitude, UserAcceleration, Gravity) -> ()) {
        if !motionManager.isDeviceMotionAvailable {
            print("Device motion not available.")
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { motion, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let motion = motion else { return }
            let rotationRate = RotationRate(x: motion.rotationRate.x,
                                            y: motion.rotationRate.y,
                                            z: motion.rotationRate.z)
            let attitude = Attitude(roll: motion.attitude.roll,
                                    pitch: motion.attitude.pitch,
                                    yaw: motion.attitude.yaw)
            let userAcceleration = UserAcceleration(x: motion.userAcceleration.x,
                                                    y: motion.userAcceleration.y,
                                                    z: motion.userAcceleration.z)
            let gravity = Gravity(x: motion.gravity.x,
                                  y: motion.gravity.y,
                                  z: motion.gravity.z)
            
            completionHandler(rotationRate, attitude, userAcceleration, gravity)
        }
    }
    
    func stopDeviceMotionUpdate() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func changeDeviceMotionUpdateInterval(to interval: Double) {
        motionManager.deviceMotionUpdateInterval = interval
    }
}
