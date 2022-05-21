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
        
        let x = currentPosition.x
        let y = currentPosition.y
        let z = currentPosition.z
        
        var speedX: Double = currentPosition.speedX
        var speedY: Double = currentPosition.speedY
        var speedZ: Double = currentPosition.speedZ
        
        let accelerationX = -motion.userAcceleration.x
        let accelerationY = -motion.userAcceleration.y
        let accelerationZ = -motion.userAcceleration.z
        
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
        
        return Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
    }
    
//    func getNewPosition(currentPosition: Position, motion: MotionData, time: Double) -> Position {
//        var speedX: Double = currentPosition.speedX
//        var speedZ: Double = currentPosition.speedZ
//        var x = currentPosition.coordinates.x
//        var z = currentPosition.coordinates.y
//        let accelerationX = -motion.userAcceleration.x
//        let accelerationZ = -motion.userAcceleration.z
//
//        x = PhysMathManager.getNewPointValue(initialP: x, initialSpeed: speedX, time: time, acceleration: accelerationX)
//        z = PhysMathManager.getNewPointValue(initialP: z, initialSpeed: speedZ, time: time, acceleration: accelerationZ)
//
//        speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: accelerationX, time: time)
//        speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: accelerationZ, time: time)
//
//        return Position(coordinates: CGPoint(x: x, y: z), speedX: speedX, speedZ: speedZ)
//    }
}

