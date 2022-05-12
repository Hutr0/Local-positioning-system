//
//  Position.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 12.05.2022.
//

import Foundation
import CoreLocation

struct Position {
    var coordinates: CLLocation
    var speedX: Double
    var speedZ: Double
}
