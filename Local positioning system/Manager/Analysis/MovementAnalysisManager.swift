//
//  MovementAnalysis.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit
import CoreLocation

class MovementAnalysisManager {
    func getNewCoordinates(currentPosition: Position, motion: MotionData, time: Double, heading: Double) -> Position {
        
        var yaw: Double = motion.attitude.yaw
        let pitch: Double = motion.attitude.pitch
        let roll: Double = motion.attitude.roll
        
        yaw = getNewYaw(yaw, fromHeading: heading)
        
        let x = currentPosition.x
        let y = currentPosition.y
        let z = currentPosition.z
        
        var acceleration = motion.userAcceleration
        
        acceleration = conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        acceleration = conversionAxes(byPitch: pitch, withAcceleration: acceleration, andWithGravityZ: motion.gravity.z)
        acceleration = conversionAxes(byRoll: roll, withAcceleration: acceleration)
        
        print("Acceleration: \(acceleration), Yaw: \(yaw)")
        
        var speedX: Double = currentPosition.speedX
        var speedY: Double = currentPosition.speedY
        var speedZ: Double = currentPosition.speedZ
           
        let newX = PhysMathManager.getNewPointValue(initialP: x, initialSpeed: speedX, time: time, acceleration: acceleration.x)
        let newY = PhysMathManager.getNewPointValue(initialP: y, initialSpeed: speedY, time: time, acceleration: acceleration.y)
        let newZ = PhysMathManager.getNewPointValue(initialP: z, initialSpeed: speedZ, time: time, acceleration: acceleration.z)
        
        speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: acceleration.x, time: time)
        speedY = PhysMathManager.getSpeed(initialSpeed: speedY, acceleration: acceleration.y, time: time)
        speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: acceleration.z, time: time)
        
        return Position(x: newX, y: newY, z: newZ, speedX: speedX, speedY: speedY, speedZ: speedZ)
    }
    
    func getNewYaw(_ yaw: Double, fromHeading heading: Double) -> Double {
        var newYaw: Double!
        let angleToBuilding = BuildingManager.shared.getAngleOfBuilding()
        
        if heading >= 180 {
            let angleToNorth = 360 - heading
            let angle = angleToNorth + angleToBuilding
            newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: -angle)
        } else {
            let angleToNorth: Double = heading
            let angle = angleToNorth - angleToBuilding
            newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        }
        
        return newYaw
    }
    
    func conversionAxes(byYaw yaw: Double, withAcceleration acceleration: UserAcceleration) -> UserAcceleration {
        let x = acceleration.x
        let y = acceleration.y
        let z = acceleration.z
        
        var newX: Double = x
        var newY: Double = y
        let newZ: Double = z
        
        if yaw <= 0 && yaw >= -1.5 {
            let percent = (yaw * 100) / -1.5
            newX = x / 100 * (100 - percent) + y / 100 * percent
            newY = y / 100 * (100 - percent) - x / 100 * percent
        } else if yaw <= -1.5 {
            let percent = ((yaw + 1.5) * 100) / -1.5
            newX = y / 100 * (100 - percent) - x / 100 * percent
            newY = -x / 100 * (100 - percent) - y / 100 * percent
        } else if yaw >= 0 && yaw <= 1.5 {
            let percent = (yaw * 100) / 1.5
            newX = -y / 100 * (100 - percent) + x / 100 * percent
            newY = x / 100 * (100 - percent) + y / 100 * percent
        } else if yaw >= 1.5 {
            let percent = ((yaw - 1.5) * 100) / 1.5
            newX = -x / 100 * (100 - percent) - y / 100 * percent
            newY = -y / 100 * (100 - percent) + x / 100 * percent
        }
        
        return UserAcceleration(x: newX, y: newY, z: newZ)
    }
    
    func conversionAxes(byPitch pitch: Double, withAcceleration acceleration: UserAcceleration, andWithGravityZ gravityZ: Double) -> UserAcceleration {
        let x = acceleration.x
        let y = acceleration.y
        let z = acceleration.z
        
        let newX: Double = x
        var newY: Double = y
        var newZ: Double = z
        
        if pitch <= 0 && pitch >= -1.5 {
            let percent = (pitch * 100) / -1.5
            if gravityZ <= 0 {
                newY = y / 100 * (100 - percent) - z / 100 * percent
                newZ = z / 100 * (100 - percent) + y / 100 * percent
            } else {
                newY = -z / 100 * percent - y / 100 * (100 - percent)
                newZ = y / 100 * percent - z / 100 * (100 - percent)
            }
        } else if pitch >= 0 && pitch <= 1.5 {
            let percent = (pitch * 100) / 1.5
            if gravityZ <= 0 {
                newY = z / 100 * percent + y / 100 * (100 - percent)
                newZ = -y / 100 * percent + z / 100 * (100 - percent)
            } else {
                newY = -y / 100 * (100 - percent) + z / 100 * percent
                newZ = -z / 100 * (100 - percent) - y / 100 * percent
            }
        }
        
        return UserAcceleration(x: newX, y: newY, z: newZ)
    }
    
    func conversionAxes(byRoll roll: Double, withAcceleration acceleration: UserAcceleration) -> UserAcceleration {
        let x = acceleration.x
        let y = acceleration.y
        let z = acceleration.z
        
        var newX: Double = x
        let newY: Double = y
        var newZ: Double = z
        
        if roll >= 0 && roll <= 1.5 {
            let percent = (roll * 100) / 1.5
            newX = x / 100 * (100 - percent) - z / 100 * percent
            newZ = z / 100 * (100 - percent) + x / 100 * percent
        } else if roll >= 1.5 {
            let percent = ((roll - 1.5) * 100) / 1.5
            newX = -z / 100 * (100 - percent) - x / 100 * percent
            newZ = x / 100 * (100 - percent) - z / 100 * percent
        } else if roll <= 0 && roll >= -1.5 {
            let percent = (roll * 100) / -1.5
            newX = z / 100 * percent + x / 100 * (100 - percent)
            newZ = -x / 100 * percent + z / 100 * (100 - percent)
        } else if roll <= -1.5 {
            let percent = ((roll + 1.5) * 100) / -1.5
            newX = -x / 100 * percent + z / 100 * (100 - percent)
            newZ = -z / 100 * percent - x / 100 * (100 - percent)
        }
        
        return UserAcceleration(x: newX, y: newY, z: newZ)
    }
}
