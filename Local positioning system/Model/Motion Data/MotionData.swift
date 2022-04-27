//
//  MotionData.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

struct MotionData {
    let rotationRate: RotationRate
    let attitude: Attitude
    let userAcceleration: UserAcceleration
    let gravity: Gravity
}
