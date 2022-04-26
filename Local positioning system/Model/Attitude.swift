//
//  Attitude.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

struct Attitude: MotionProtocol {
    let roll: Double
    let pitch: Double
    let yaw: Double
    
    init(roll: Double, pitch: Double, yaw: Double) {
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
    
    init(first: Double, second: Double, fird: Double) {
        self.roll = first
        self.pitch = second
        self.yaw = fird
    }
    
    func deconstruct() -> [Double] {
        var array: [Double] = []
     
        array.append(self.roll)
        array.append(self.pitch)
        array.append(self.yaw)
        
        return array
    }
}
