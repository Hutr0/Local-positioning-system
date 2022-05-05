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
    
    var currentCoordinates: CLLocation!
    
    func startRecordingMotions(coordinatesOfStart: CLLocation, closure: @escaping (CLLocation) -> ()) {
        
        var mdForReducingInaccurancy: [MotionData] = []
        var motionsData: [MotionData] = []
        currentCoordinates = coordinatesOfStart
        
        positioningMotionManager.changeDeviceMotionUpdateInterval(to: 0.01)
        positioningMotionManager.startDeviceMotionUpdate { [weak self] rotationRate, attitude, userAcceleration, gravity in
            guard let self = self else { return }
            
            mdForReducingInaccurancy.append(MotionData(rotationRate: rotationRate,
                                                       attitude: attitude,
                                                       userAcceleration: userAcceleration,
                                                       gravity: gravity))
            
            if mdForReducingInaccurancy.count >= 10 {
                let data = self.reducingInaccurancy(data: mdForReducingInaccurancy)
                mdForReducingInaccurancy.removeAll()
                
                motionsData.append(data)
            }
            
            if motionsData.count >= 10 {
                self.updateCoordinates(motionsData: motionsData, closure: closure)
                motionsData.removeAll()
            }
        }
    }
    
    func updateCoordinates(motionsData: [MotionData], closure: @escaping (CLLocation) -> ()) {
        let newCoordinates = movementAnalysisManager.getNewCoordinates(currentCoordonates: currentCoordinates, motions: motionsData)
        
        currentCoordinates = newCoordinates
        closure(newCoordinates)
    }
    
    func reducingInaccurancy(data: [MotionData]) -> MotionData {
        return reducingInaccurancyManager.reduceInaccurancy(motionsData: data)
    }
}
