//
//  LocationManagerDelegate.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    lazy var locationServicesManager = LocationServicesManager.shared
    var completionHandler: ((CLLocation) -> ())?
    var completionHeading: ((CLHeading) -> ())?
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationServicesManager.checkLocationAutorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, let completionHandler = completionHandler else { return }
//        completionHandler(location)
        completionHandler(CLLocation(latitude: 55.672423427107134, longitude: 37.47909789405624))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard let completion = completionHeading else { return }
        completion(newHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AlertManager.showAlert(title: "Location manager did fail with error.", message: error.localizedDescription)
    }
}
