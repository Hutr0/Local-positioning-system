//
//  Positioning Manager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit
import CoreLocation

class PositioningManager {
    
    let positioningMotionManager = PositioningMotionManager()
    let reducingInaccurancyManager = ReducingInaccuracyManager()
    let movementAnalysisManager = MovementAnalysisManager()
    
    var currentPosition: Position!
    let timeInterval = 0.01
    
    func startRecordingMotions(coordinatesOfStart: CLLocation, closure: @escaping (CLLocation) -> ()) {
        var mdForReducingInaccurancy: [MotionData] = []
        currentPosition = Position(coordinates: coordinatesOfStart, speedX: 0, speedZ: 0)
        
        positioningMotionManager.changeDeviceMotionUpdateInterval(to: timeInterval)
        positioningMotionManager.startDeviceMotionUpdate { [weak self] rotationRate, attitude, userAcceleration, gravity in
            guard let self = self else { return }
            
            mdForReducingInaccurancy.append(MotionData(rotationRate: rotationRate,
                                                       attitude: attitude,
                                                       userAcceleration: userAcceleration,
                                                       gravity: gravity))
            
            if mdForReducingInaccurancy.count >= 5 {
                let data = self.reducingInaccurancy(data: mdForReducingInaccurancy)
                mdForReducingInaccurancy.removeAll()
                
                self.updateCoordinates(motionData: data, closure: closure)
            }
        }
    }
    
    func updateCoordinates(motionData: MotionData, closure: @escaping (CLLocation) -> ()) {
        let newPosition = movementAnalysisManager.getNewCoordinates(currentPosition: currentPosition, motion: motionData, time: timeInterval)
        
        currentPosition = newPosition
        closure(newPosition.coordinates)
    }
    
    func reducingInaccurancy(data: [MotionData]) -> MotionData {
        return reducingInaccurancyManager.reduceInaccurancy(motionsData: data)
    }
}
