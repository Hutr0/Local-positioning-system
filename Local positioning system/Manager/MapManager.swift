//
//  MapManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation


class MapManager {
    var buildingCoordinate = BuildingCoordinate()
    var buildingArea = BuildingArea()
    
    let locationServicesManager = LocationServicesManager()
    
    func setupLocationServices() {
        locationServicesManager.checkLocationServices()
    }
}
