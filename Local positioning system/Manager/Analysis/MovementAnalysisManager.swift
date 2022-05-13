//
//  MovementAnalysis.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation
import CoreLocation

class MovementAnalysisManager {
    func getNewCoordinates(currentPosition: Position, motion: MotionData, time: Double) -> Position {
        let result = getNewPosition(currentPosition: currentPosition, motion: motion, time: time)
        
        return result
    }
    
    func getNewPosition(currentPosition: Position, motion: MotionData, time: Double) -> Position {
        var speedX: Double = currentPosition.speedX
        var speedZ: Double = currentPosition.speedZ
        var x = currentPosition.coordinates.coordinate.longitude
        var z = currentPosition.coordinates.coordinate.latitude
        let accelerationX = -motion.userAcceleration.x
        let accelerationZ = -motion.userAcceleration.z
        
        x = PhysMathManager.getNewPointValue(initialP: x, initialSpeed: speedX, time: time, acceleration: accelerationX)
        z = PhysMathManager.getNewPointValue(initialP: z, initialSpeed: speedZ, time: time, acceleration: accelerationZ)
        
        speedX = PhysMathManager.getSpeed(initialSpeed: speedX, acceleration: accelerationX, time: time)
        speedZ = PhysMathManager.getSpeed(initialSpeed: speedZ, acceleration: accelerationZ, time: time)
        
        return Position(coordinates: CLLocation(latitude: z, longitude: x), speedX: speedX, speedZ: speedZ)
    }
}
