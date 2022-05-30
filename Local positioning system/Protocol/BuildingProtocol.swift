//
//  CoordinateProtocol.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation

protocol BuildingProtocol {
    var buildingManager: BuildingDataManager { get }
    
    var leftBottom: CLLocationCoordinate2D { get set }
    var leftTop: CLLocationCoordinate2D { get set }
    var rightBottom: CLLocationCoordinate2D { get set }
    var rightTop: CLLocationCoordinate2D { get set }
    
    init()
}
