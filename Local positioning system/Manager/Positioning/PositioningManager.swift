//
//  Positioning Manager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import UIKit
import CoreLocation

class PositioningManager {
    
    let motionManager = MotionManager()
    let reducingInaccurancyManager = ReducingInaccuracyManager()
    let movementAnalysisManager = MovementAnalysisManager()
    
    var currentPosition: Position!
    let timeInterval = 0.01
    
    func startRecordingMotions(pointOfStart: CGPoint, closure: @escaping (CGPoint) -> ()) {
        var mdForReducingInaccurancy: [MotionData] = []
        currentPosition = Position(x: pointOfStart.x, y: 0, z: pointOfStart.y, speedX: 0, speedY: 0, speedZ: 0)
        
        var magneticHeading: Double?
        let timer = TimerManager()
        timer.startTimer(timeInterval: 0.01) {
            if magneticHeading != nil {
                timer.stopTimer()
                return
            }
            
            LocationServicesManager.shared.getCurrentMagneticHeading { heading in
                guard let heading = heading else { return }
                magneticHeading = heading
            }
        }
        
        motionManager.changeDeviceMotionUpdateInterval(to: timeInterval)
        motionManager.startDeviceMotionUpdate { [weak self] rotationRate, attitude, userAcceleration, gravity in
            guard let self = self else { return }
            
            mdForReducingInaccurancy.append(MotionData(rotationRate: rotationRate,
                                                       attitude: attitude,
                                                       userAcceleration: userAcceleration,
                                                       gravity: gravity))
            
            if mdForReducingInaccurancy.count >= 5 && magneticHeading != nil {
                let data = self.reducingInaccurancy(data: mdForReducingInaccurancy)
                mdForReducingInaccurancy.removeAll()
                
                self.updateCoordinates(heading: magneticHeading!, motionData: data, closure: closure)
            }
            
            if mdForReducingInaccurancy.count >= 20 && magneticHeading == nil {
                AlertManager.showAlert(title: "Magnetic heading cannot be gained", message: "Your current angle to north will set to zero")
                magneticHeading = 0
            }
        }
    }
    
    func updateCoordinates(heading: Double, motionData: MotionData, closure: @escaping (CGPoint) -> ()) {
        let newPosition = movementAnalysisManager.getNewCoordinates(currentPosition: currentPosition, motion: motionData, time: timeInterval, heading: heading)
        
        currentPosition = newPosition
        closure(CGPoint(x: newPosition.x, y: newPosition.z))
    }
    
    func reducingInaccurancy(data: [MotionData]) -> MotionData {
        return reducingInaccurancyManager.reduceInaccurancy(motionsData: data)
    }
}
