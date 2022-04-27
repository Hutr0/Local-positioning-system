//
//  RotationRate.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

struct RotationRate: MotionProtocol {
    let x: Double
    let y: Double
    let z: Double
    
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(first: Double, second: Double, fird: Double) {
        self.x = first
        self.y = second
        self.z = fird
    }
    
    func deconstruct() -> [Double] {
        var array: [Double] = []
        
        array.append(self.x)
        array.append(self.y)
        array.append(self.z)
        
        return array
    }
}
