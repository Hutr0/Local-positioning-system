//
//  ReducingInaccuracy.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

class ReducingInaccuracyManager {
    
    func reduceInaccurancy(motionsData: [MotionData]) -> MotionData {
        var rotationRateElementsForReducingInaccurancy: [RotationRate] = []
        for element in motionsData {
            rotationRateElementsForReducingInaccurancy.append(element.rotationRate)
        }
        let rotationRate = reduceInaccurancyOfElements(array: rotationRateElementsForReducingInaccurancy)
        
        var attitudeElementsForReducingInaccurancy: [Attitude] = []
        for element in motionsData {
            attitudeElementsForReducingInaccurancy.append(element.attitude)
        }
        let attitude = reduceInaccurancyOfElements(array: attitudeElementsForReducingInaccurancy)
        
        var userAccelerationElementsForReducingInaccurancy: [UserAcceleration] = []
        for element in motionsData {
            userAccelerationElementsForReducingInaccurancy.append(element.userAcceleration)
        }
        let userAcceleration = reduceInaccurancyOfElements(array: userAccelerationElementsForReducingInaccurancy)
        
        var gravithElementsForReducingInaccurancy: [Gravity] = []
        for element in motionsData {
            gravithElementsForReducingInaccurancy.append(element.gravity)
        }
        let gravity = reduceInaccurancyOfElements(array: gravithElementsForReducingInaccurancy)
        
        return MotionData(rotationRate: rotationRate, attitude: attitude, userAcceleration: userAcceleration, gravity: gravity)
    }
    
    func reduceInaccurancyOfElements<T: MotionProtocol>(array: [T]) -> T {
        var elementsFirst: [Double] = []
        var elementsSecond: [Double] = []
        var elementsFird: [Double] = []
        
        for element in array {
            let values = element.deconstruct()
            
            elementsFirst.append(values[0])
            elementsSecond.append(values[1])
            elementsFird.append(values[2])
        }
        
        var sumFirst: Double = 0
        for first in elementsFirst {
            sumFirst += first
        }
        let newFirst = sumFirst / Double(elementsFirst.count)
        
        var sumSecond: Double = 0
        for second in elementsSecond {
            sumSecond += second
        }
        let newSecond = sumSecond / Double(elementsSecond.count)
        
        var sumFird: Double = 0
        for fird in elementsFird {
            sumFird += fird
        }
        let newFird = sumFird / Double(elementsFird.count)
        
        return T(first: newFirst, second: newSecond, fird: newFird)
    }
}
