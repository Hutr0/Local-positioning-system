//
//  LocationServicesManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import MapKit

class LocationServicesManager {
    
    static let shared = LocationServicesManager()
    
    private init() {}
    
    let locationManager = CLLocationManager()
    var locationManagerDelegate: LocationManagerDelegate!
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAutorization()
            
            locationManagerDelegate = LocationManagerDelegate(locationServicesManager: self)
            locationManager.delegate = locationManagerDelegate
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                AlertManager.showAlert(title: "Location Services are Disabled", message: "To endable it go: Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    func checkLocationAutorization() {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse, .authorizedAlways:
                break
            case .denied, .restricted:
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    AlertManager.showAlert(title: "Location Services are denied", message: "To enable your location tracking: Setting -> MyPlaces -> Location")
                }
                break
            @unknown default:
                print("New cases was added")
        }
    }
    
    func getCurrentMagneticHeading(onCompletion completion: @escaping (CLLocationDirection?) -> ()) {
        guard CLLocationManager.headingAvailable() else {
            AlertManager.showAlert(title: "Heading is not available", message: "Your current angle to north will set to zero")
            completion(nil)
            return
        }
        
        let completionHeading: ((CLHeading) -> ()) = { [weak self] heading in
            guard let self = self else { return }
            
            completion(heading.magneticHeading)
            self.locationManager.stopUpdatingHeading()
        }
        
        guard let lmd = locationManager.delegate as? LocationManagerDelegate else { return }
        lmd.completionHeading = completionHeading
        locationManager.startUpdatingHeading()
    }
}
