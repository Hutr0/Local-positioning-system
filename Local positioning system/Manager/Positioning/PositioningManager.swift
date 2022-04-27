//
//  Positioning Manager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

class PositioningManager {
    
    let positioningMotionManager = PositioningMotionManager()
    let reducingInaccurancyManager = ReducingInaccuracyManager()
    let movementAnalysisManager = MovementAnalysisManager()
    
    var motionsData: [MotionData] = []
    
    func startRecordingMotions() {
        
        var mdForReducingInaccurancy: [MotionData] = []
        
        positioningMotionManager.startDeviceMotionUpdate { rotationRate, attitude, userAcceleration, gravity in
            
            mdForReducingInaccurancy.append(MotionData(rotationRate: rotationRate,
                                                       attitude: attitude,
                                                       userAcceleration: userAcceleration,
                                                       gravity: gravity))
            
            if mdForReducingInaccurancy.count >= 10 {
                self.reducingInaccurancy(data: mdForReducingInaccurancy)
                mdForReducingInaccurancy.removeAll()
            }
        }
    }
    
    func reducingInaccurancy(data: [MotionData]) {
        let result = reducingInaccurancyManager.reduceInaccurancy(motionsData: data)
        
        motionsData.append(result)
        
        if self.motionsData.count > 100 {
            self.motionsData.removeFirst()
        }
    }
}
