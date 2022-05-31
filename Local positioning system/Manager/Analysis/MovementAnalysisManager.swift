//
//  MovementAnalysis.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit
import CoreLocation

class MovementAnalysisManager {
    
    var isAccelerationX: Bool = true
    var isPositiveSignX: Bool? = nil
    var maxValueX: Double = 0
    
    var isAccelerationY = true
    var isPositiveSignY: Bool? = nil
    var maxValueY: Double = 0
    
    var isAccelerationZ = true
    var isPositiveSignZ: Bool? = nil
    var maxValueZ: Double = 0
    
    func getNewCoordinates(currentPosition: Position, motion: MotionData, time: Double, heading: Double) -> Position {
        
        var yaw: Double = motion.attitude.yaw
        let pitch: Double = motion.attitude.pitch
        let roll: Double = motion.attitude.roll
        
        yaw = getNewYaw(yaw, fromHeading: heading)
        
        let x = currentPosition.x
        let y = currentPosition.y
        let z = currentPosition.z
        
        var acceleration = motion.userAcceleration
        
        if NSString(format: "%.1f", acceleration.x) == "0.0" || NSString(format: "%.1f", acceleration.x) == "-0.0" {
            acceleration.x = 0
        }
        if NSString(format: "%.1f", acceleration.y) == "0.0" || NSString(format: "%.1f", acceleration.y) == "-0.0" {
            acceleration.y = 0
        }
        if NSString(format: "%.1f", acceleration.z) == "0.0" || NSString(format: "%.1f", acceleration.z) == "-0.0" {
            acceleration.z = 0
        }
        
//        print("Acceleration: \(acceleration)")
        
        acceleration = conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        acceleration = conversionAxes(byPitch: pitch, withAcceleration: acceleration, andWithGravityZ: motion.gravity.z)
        acceleration = conversionAxes(byRoll: roll, withAcceleration: acceleration)
        
        acceleration.x = acceleration.x * 9.81
        acceleration.y = acceleration.y * 9.81
        acceleration.z = acceleration.z * 9.81
        
        print("-------------\nx: \(acceleration.x)\ny: \(acceleration.y)\nz: \(acceleration.z)")
        
        var speedX: Double = currentPosition.speedX
        var speedY: Double = currentPosition.speedY
        var speedZ: Double = currentPosition.speedZ
           
        var newX: Double = x
        var newY: Double = y
        var newZ: Double = z
        
//        newX = PhysMathManager.getNewPointValue(initialP: x, initialSpeed: speedX, time: time, acceleration: acceleration.x)
//        newY = PhysMathManager.getNewPointValue(initialP: y, initialSpeed: speedY, time: time, acceleration: acceleration.y)
//        newZ = PhysMathManager.getNewPointValue(initialP: z, initialSpeed: speedZ, time: time, acceleration: acceleration.z)
        
        if isPositiveSignX == nil {
            if NSString(format: "%.1f", acceleration.x) != "0.0" && NSString(format: "%.1f", acceleration.x) != "-0.0" {
                isPositiveSignX = acceleration.x > 0 ? true : false
            }
        }
        if isPositiveSignY == nil {
            if NSString(format: "%.1f", acceleration.y) != "0.0" && NSString(format: "%.1f", acceleration.y) != "-0.0" {
                isPositiveSignY = acceleration.y > 0 ? true : false
            }
        }
        if isPositiveSignZ == nil {
            if NSString(format: "%.1f", acceleration.z) != "0.0" && NSString(format: "%.1f", acceleration.z) != "-0.0" {
                isPositiveSignZ = acceleration.z > 0 ? true : false
            }
        }

        if isPositiveSignX != nil {
            if isAccelerationX {
                if (acceleration.x > 0) == isPositiveSignX && acceleration.x != 0 {
                    newX = PhysMathManager.getNewPointValue(initialP: x, initialSpeed: speedX, time: time, acceleration: acceleration.x)
//                    speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: acceleration.x, time: time)
                    maxValueX += acceleration.x
                } else {
//                    isPositiveSignX!.toggle()
                    isAccelerationX = false
                    maxValueX += acceleration.x
                }
            } else {
                if (maxValueX < 0) == isPositiveSignX {
//                    if NSString(format: "%.1f", acceleration.x) == "0.0" || NSString(format: "%.1f", acceleration.x) == "-0.0" {
                        isPositiveSignX = nil
                        isAccelerationX = true
//                        speedX = 0
//                        acceleration.x = 0.000
                        maxValueX = 0
//                    }
                } else {
                    maxValueX += acceleration.x
                }
            }
        }
        if isPositiveSignY != nil {
            if isAccelerationY {
                if (acceleration.y > 0) == isPositiveSignY && acceleration.y != 0 {
                    newY = PhysMathManager.getNewPointValue(initialP: y, initialSpeed: speedY, time: time, acceleration: acceleration.y)
//                    speedY = PhysMathManager.getSpeed(initialSpeed: speedY, acceleration: acceleration.y, time: time)
                    maxValueY += acceleration.y
                } else {
//                    isPositiveSignY!.toggle()
                    isAccelerationY = false
                    maxValueY += acceleration.y
                }
            } else {
                if (maxValueY < 0) == isPositiveSignY {
//                    if NSString(format: "%.1f", acceleration.y) == "0.0" || NSString(format: "%.1f", acceleration.y) == "-0.0" {
                        isPositiveSignY = nil
                        isAccelerationY = true
//                        speedY = 0
//                        acceleration.y = 0.000
                        maxValueY = 0
//                    }
                } else {
                    maxValueY += acceleration.y
                }
            }
        }
        if isPositiveSignZ != nil {
            if isAccelerationZ {
                if (acceleration.z > 0) == isPositiveSignZ && acceleration.z != 0 {
                    newZ = PhysMathManager.getNewPointValue(initialP: z, initialSpeed: speedZ, time: time, acceleration: acceleration.z)
//                    speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: acceleration.z, time: time)
                    maxValueZ += acceleration.z
                } else {
//                    isPositiveSignZ!.toggle()
                    isAccelerationZ = false
                    maxValueZ += acceleration.z
                }
            } else {
                if (maxValueZ < 0) == isPositiveSignZ {
//                    if NSString(format: "%.1f", acceleration.z) == "0.0" || NSString(format: "%.1f", acceleration.z) == "-0.0" {
                        isPositiveSignZ = nil
                        isAccelerationZ = true
//                        speedZ = 0
//                        acceleration.z = 0.000
                        maxValueZ = 0
//                    }
                } else {
                    maxValueZ += acceleration.z
                }
            }
        }
        
//        speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: acceleration.x, time: time)
//        speedY = PhysMathManager.getSpeed(initialSpeed: speedY, acceleration: acceleration.y, time: time)
//        speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: acceleration.z, time: time)
        
        if NSString(format: "%.1f", acceleration.x) == "0.0" || NSString(format: "%.1f", acceleration.x) == "-0.0" {
            speedX = 0
        } else {
            speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: acceleration.x, time: time)
        }

        if NSString(format: "%.1f", acceleration.y) == "0.0" || NSString(format: "%.1f", acceleration.y) == "-0.0" {
            speedY = 0
        } else {
            speedY = PhysMathManager.getSpeed(initialSpeed: speedY, acceleration: acceleration.y, time: time)
        }

        if NSString(format: "%.1f", acceleration.z) == "0.0" || NSString(format: "%.1f", acceleration.z) == "-0.0" {
            speedZ = 0
        } else {
            speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: acceleration.z, time: time)
        }
        
        print("Speed X: \(speedX), \nSpeed Y: \(speedY), \nSpeed Z: \(speedZ)")
        
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

//        if acceleration.x == 0 {
//            speedX = 0
//        } else {
//            speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: acceleration.x, time: time)
//        }
//        if acceleration.y == 0 {
//            speedY = 0
//        } else {
//            speedY = PhysMathManager.getSpeed(initialSpeed: speedY, acceleration: acceleration.y, time: time)
//        }
//        if acceleration.z == 0 {
//            speedZ = 0
//        } else {
//            speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: acceleration.z, time: time)
//        }

//        if isPositiveSignX == nil { isPositiveSignX = acceleration.x > 0 ? true : false }
//        if isPositiveSignY == nil { isPositiveSignY = acceleration.y > 0 ? true : false }
//        if isPositiveSignZ == nil { isPositiveSignZ = acceleration.z > 0 ? true : false }
//
//        if isAccelerationX {
//            if (acceleration.x > 0) == isPositiveSignX {
//                speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: acceleration.x, time: time)
//            }
//            else {
//                isPositiveSignX!.toggle()
//                isAccelerationX = false
//            }
//        } else {
//            if NSString(format: "%.2f", acceleration.x) == "0.00" || NSString(format: "%.2f", acceleration.x) == "-0.00" {
//                isPositiveSignX = nil
//                isAccelerationX = true
//                speedX = 0
//            }
//        }
//
//        if isAccelerationY {
//            if (acceleration.y > 0) == isPositiveSignY {
//                speedY = PhysMathManager.getSpeed(initialSpeed: speedY, acceleration: acceleration.y, time: time)
//            }
//            else {
//                isPositiveSignY!.toggle()
//                isAccelerationY = false
//            }
//        } else {
//            if NSString(format: "%.1f", acceleration.y) == "0.0" || NSString(format: "%.1f", acceleration.y) == "-0.0" {
//                isPositiveSignY = nil
//                isAccelerationY = true
//                speedY = 0
//            }
//        }
//
//        if isAccelerationZ {
//            if (acceleration.z > 0) == isPositiveSignZ {
//                speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: acceleration.z, time: time)
//            }
//            else {
//                isPositiveSignZ!.toggle()
//                isAccelerationZ = false
//            }
//        } else {
//            if NSString(format: "%.1f", acceleration.z) == "0.0" || NSString(format: "%.1f", acceleration.z) == "-0.0" {
//                isPositiveSignZ = nil
//                isAccelerationZ = true
//                speedZ = 0
//            }
//        }
        
//        speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: acceleration.x, time: time)
//        speedY = PhysMathManager.getSpeed(initialSpeed: speedY, acceleration: acceleration.y, time: time)
//        speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: acceleration.z, time: time)0
