//
//  File.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import Foundation

protocol MotionProtocol {
    init(first: Double, second: Double, fird: Double)
    func deconstruct() -> [Double]
}
