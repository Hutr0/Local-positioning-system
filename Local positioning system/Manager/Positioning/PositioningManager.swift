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
    
    var motionsData: [MotionData]!
    var currentCoordinates: CLLocation!
    
    func startRecordingMotions(coordinatesOfStart: CLLocation, closure: @escaping (CLLocation) -> ()) {
        
        var mdForReducingInaccurancy: [MotionData] = []
        motionsData = []
        currentCoordinates = coordinatesOfStart
        
        positioningMotionManager.startDeviceMotionUpdate { [weak self] rotationRate, attitude, userAcceleration, gravity in
            guard let self = self else { return }
            
            mdForReducingInaccurancy.append(MotionData(rotationRate: rotationRate,
                                                       attitude: attitude,
                                                       userAcceleration: userAcceleration,
                                                       gravity: gravity))
            
            if mdForReducingInaccurancy.count >= 10 {
                self.reducingInaccurancy(data: mdForReducingInaccurancy)
                mdForReducingInaccurancy.removeAll()
            }
            
            self.updateCoordinates(closure: closure)
        }
    }
    
    func updateCoordinates(closure: @escaping (CLLocation) -> ()) {
        var newCoordinates = movementAnalysisManager.getNewCoordinates(motions: motionsData)
        
        currentCoordinates = newCoordinates
        closure(newCoordinates)
    }
    
    func reducingInaccurancy(data: [MotionData]) {
        let result = reducingInaccurancyManager.reduceInaccurancy(motionsData: data)
        
        motionsData.append(result)
        
        if self.motionsData.count > 100 {
            self.motionsData.removeFirst()
        }
    }
}
