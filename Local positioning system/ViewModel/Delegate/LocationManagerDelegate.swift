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
    var completionHandler: ((CLLocation) -> ())?
    
    init(locationServicesManager: LocationServicesManager) {
        self.locationServicesManager = locationServicesManager
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationServicesManager.checkLocationAutorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, let completionHandler = completionHandler else { return }
        completionHandler(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
