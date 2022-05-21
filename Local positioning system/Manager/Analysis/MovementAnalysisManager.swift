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
    
    private func getNewYaw(_ yaw: Double, fromHeading heading: Double) -> Double {
        var yaw: Double!
        let angleToBuilding = BuildingManager.shared.getAngleOfBuilding()
        
        if heading >= 180 {
            let angleToNorth = 360 - heading
            let angle = angleToNorth - angleToBuilding
            yaw = PhysMathManager.rotateAttitude(value: yaw, byAngle: -angle)
        } else {
            let angleToNorth: Double = heading
            let angle = angleToNorth - angleToBuilding
            yaw = PhysMathManager.rotateAttitude(value: yaw, byAngle: angle)
        }
        
        return yaw
    }
    
    private func conversionAxes(byYaw yaw: Double, withAcceleration acceleration: UserAcceleration) -> UserAcceleration {
        var x = acceleration.x
        var y = acceleration.y
        let z = acceleration.z
        
        if yaw <= 0 && yaw >= -1.5 {
            let percent = (yaw * 100) / -1.5
            x = x / 100 * (100 - percent) + y / 100 * percent
            y = y / 100 * (100 - percent) - x / 100 * percent
        } else if yaw <= -1.5 && yaw >= -3 {
            let percent = ((yaw + 1.5) * 100) / -1.5
            x = y / 100 * (100 - percent) - x / 100 * percent
            y = -x / 100 * (100 - percent) - y / 100 * percent
        } else if yaw >= 0 && yaw <= 1.5 {
            let percent = (yaw * 100) / 1.5
            x = -y / 100 * (100 - percent) + x / 100 * percent
            y = x / 100 * (100 - percent) + y / 100 * percent
        } else if yaw >= 1.5 && yaw <= 3 {
            let percent = ((yaw - 1.5) * 100) / 1.5
            x = -x / 100 * (100 - percent) - y / 100 * percent
            y = -y / 100 * (100 - percent) + x / 100 * percent
        }
        
        return UserAcceleration(x: x, y: y, z: z)
    }
    
    private func conversionAxes(byPitch pitch: Double, withAcceleration acceleration: UserAcceleration, andWithGravityZ gravityZ: Double) -> UserAcceleration {
        let x = acceleration.x
        var y = acceleration.y
        var z = acceleration.z
        
        if pitch <= 0 && pitch >= -1.5 {
            let percent = (pitch * 100) / -1.5
            if gravityZ <= 0 {
                y = y / 100 * (100 - percent) - z / 100 * percent
                z = -z / 100 * (100 - percent) - y / 100 * percent
            } else {
                y = -z / 100 * percent - y / 100 * (100 - percent)
                z = -y / 100 * percent + z / 100 * (100 - percent)
            }
        } else if pitch >= 0 && pitch <= 1.5 {
            let percent = (pitch * 100) / 1.5
            if gravityZ <= 0 {
                y = z / 100 * percent + y / 100 * (100 - percent)
                z = y / 100 * percent - z / 100 * (100 - percent)
            } else {
                y = -y / 100 * (100 - percent) + z / 100 * percent
                z = z / 100 * (100 - percent) + y / 100 * percent
            }
        }
        
        return UserAcceleration(x: x, y: y, z: z)
    }
    
    private func conversionAxes(byRoll roll: Double, withAcceleration acceleration: UserAcceleration) -> UserAcceleration {
        var x = acceleration.x
        let y = acceleration.y
        var z = acceleration.z
        
        if roll >= 0 && roll <= 1.5 {
            let percent = (roll * 100) / 1.5
            z = -z / 100 * (100 - percent) - x / 100 * percent
            x = -x / 100 * (100 - percent) + z / 100 * percent
        } else if roll >= 1.5 && roll <= 3 {
            let percent = ((roll - 1.5) * 100) / 1.5
            z = -x / 100 * (100 - percent) + z / 100 * percent
            x = -z / 100 * (100 - percent) + x / 100 * percent
        } else if roll <= 0 && roll >= -1.5 {
            let percent = (roll * 100) / -1.5
            z = -z / 100 * (100 - percent) + x / 100 * percent
            x = -x / 100 * (100 - percent) - z / 100 * percent
        } else if roll <= -1.5 && roll >= -3 {
            let percent = ((roll + 1.5) * 100) / -1.5
            z = x / 100 * (100 - percent) + z / 100 * percent
            x = -z / 100 * (100 - percent) + x / 100 * percent
        }
        
        return UserAcceleration(x: x, y: y, z: z)
    }
}

//        LocationServicesManager.shared.getCurrentMagneticHeading { magneticHeading in
//            var heading: CLLocationDirection!
//            if magneticHeading == nil {
//                heading = 0
//            } else {
//                heading = magneticHeading
//            }
//
//
//
//            print(yaw)
//        }
        
//        let result = getNewPosition(currentPosition: currentPosition, motion: motion, time: time)
        
//        let angle = BuildingManager.shared.getAngleOfBuilding()
//        let yaw = PhysMathManager.rotateAttitude(value: motion.attitude.yaw, byAngle: angle)
//
//        var yawAngle: Double = 0
//        if yaw < 0 {
//            yawAngle = (180 * yaw) / (-3)
//        } else {
//            yawAngle = (180 * yaw) / (3)
//        }
//
//        let x = currentPosition.x
//        let y = currentPosition.y
//        let z = currentPosition.z
//
//        var speedX: Double = currentPosition.speedX
//        var speedY: Double = currentPosition.speedY
//        var speedZ: Double = currentPosition.speedZ
//
//        let accelerationX = -motion.userAcceleration.x
//        let accelerationY = -motion.userAcceleration.y
//        let accelerationZ = -motion.userAcceleration.z
        
//        let newX = PhysMathManager.getNewPointValue(initialP: x, initialSpeed: speedX, time: time, acceleration: accelerationX)
//        let newY = PhysMathManager.getNewPointValue(initialP: y, initialSpeed: speedY, time: time, acceleration: accelerationY)
//        let newZ = PhysMathManager.getNewPointValue(initialP: z, initialSpeed: speedZ, time: time, acceleration: accelerationZ)
        
//        let a = motion.userAcceleration.x + motion.userAcceleration.y + motion.userAcceleration.z
        
//        let newPointValue = PhysMathManager.getNewPointValue(initialP: x, initialSpeed: speedX, time: time, acceleration: a)
        
//        let correctNewPointValue = PhysMathManager.rotatePoint(pointToRotate: CGPoint(x: newPointValue, y: y), centerPoint: CGPoint(x: x, y: y), angleInDegrees: yawAngle)
        
//        let correctNewX = PhysMathManager.rotatePoint(pointToRotate: CGPoint(x: newX, y: newY), centerPoint: CGPoint(x: x, y: y), angleInDegrees: yawAngle)
//        let correctNewY = PhysMathManager.rotatePoint(pointToRotate: CGPoint(x: newY, y: newZ), centerPoint: CGPoint(x: y, y: z), angleInDegrees: yawAngle)
//        let correctNewZ = PhysMathManager.rotatePoint(pointToRotate: CGPoint(x: newZ, y: newX), centerPoint: CGPoint(x: z, y: x), angleInDegrees: yawAngle)
        
//        let pitch = motion.attitude.pitch
//        let pitchPercent: Double = PhysMathManager.calculatePercent(number: pitch, hundredPercentNumber: 1.5)
//
//        let pitchZ = (max(100, pitchPercent) - min(100, pitchPercent))
        
        
//        var result = Position(coordinates: CGPoint(), speedX: 0, speedY: 0, speedZ: 0)
//        result.coordinates = correctNewPointValue
//
//        return result
