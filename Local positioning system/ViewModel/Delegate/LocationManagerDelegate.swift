//
//  LocationManagerDelegate.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    var locationServicesManager: LocationServicesManager!
    
    init(locationServicesManager: LocationServicesManager) {
        self.locationServicesManager = locationServicesManager
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationServicesManager.checkLocationAutorization()
    }
}
