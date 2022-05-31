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
    let timeInterval: Double = 1/60
    let countOfValuesForReducingInacurancy = 5
    
    func startRecordingMotions(pointOfStart: CGPoint, closure: @escaping (CGPoint) -> ()) {
        var mdForReducingInaccurancy: [MotionData] = []
        currentPosition = Position(x: pointOfStart.x, y: pointOfStart.y, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        
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
            
//            self.updateCoordinates(heading: magneticHeading ?? 0,
//                                   motionData: MotionData(rotationRate: rotationRate,
//                                                          attitude: attitude,
//                                                          userAcceleration: userAcceleration,
//                                                          gravity: gravity),
//                                   closure: closure)
            
            mdForReducingInaccurancy.append(MotionData(rotationRate: rotationRate,
                                                       attitude: attitude,
                                                       userAcceleration: userAcceleration,
                                                       gravity: gravity))
            
            if mdForReducingInaccurancy.count >= self.countOfValuesForReducingInacurancy && magneticHeading != nil {
                let data = self.reducingInaccurancy(data: mdForReducingInaccurancy)
                mdForReducingInaccurancy.removeAll()

                self.updateCoordinates(heading: magneticHeading ?? 0, motionData: data, closure: closure)
            }
            
            if mdForReducingInaccurancy.count >= self.countOfValuesForReducingInacurancy * 2 && magneticHeading == nil {
                AlertManager.showAlert(title: "Magnetic heading cannot be gained", message: "Your current angle to north will set to zero")
                magneticHeading = 0
            }
        }
    }
    
    func updateCoordinates(heading: Double, motionData: MotionData, closure: @escaping (CGPoint) -> ()) {
        let newPosition = movementAnalysisManager.getNewCoordinates(currentPosition: currentPosition, motion: motionData, time: timeInterval * Double(countOfValuesForReducingInacurancy), heading: heading)
        
        currentPosition = newPosition
        
        let mapPoint = MapManager.convertPointFromMetersToMap(point: CGPoint(x: newPosition.x, y: newPosition.y))
        
        closure(mapPoint)
    }
    
    func reducingInaccurancy(data: [MotionData]) -> MotionData {
        return reducingInaccurancyManager.reduceInaccurancy(motionsData: data)
    }
    
//    func getNewCoord() {}
//    func reduceSpeed() {}
//    func a() {
//        let data: Double = 0.0
//        var isAcceleration = true
//        var isPositiveSign: Bool? = nil
//
//        if isPositiveSign == nil { isPositiveSign = data < 0 ? false : true }
//
//        if isAcceleration {
//            if (data < 0) == isPositiveSign { getNewCoord() }
//            else {
//                isPositiveSign!.toggle()
//                isAcceleration = false
//                reduceSpeed()
//            }
//        } else {
//            if (data < 0) != isPositiveSign {
//                isAcceleration = true
//                isPositiveSign!.toggle()
//                getNewCoord()
//            } else {
//                reduceSpeed()
//            }
//        }
//    }
//    func b() {
//        let data: Double = 0.0
//        var previousData: Double = 0.0
//        var isPositiveSign: Bool? = nil
//
//        if isPositiveSign == nil { isPositiveSign = data < 0 ? false : true }
//
//        if (data < 0) == isPositiveSign {
//            previousData = data
//            getNewCoord()
//        } else {
//            if isPositiveSign! {
//                if data >= previousData {
//                    previousData = data
//                    getNewCoord()
//                } else {
//                    //
//                }
//            } else {
//                if data <= previousData {
//                    previousData = data
//                    getNewCoord()
//                } else {
//                    //
//                }
//            }
//        }
//    }
}
