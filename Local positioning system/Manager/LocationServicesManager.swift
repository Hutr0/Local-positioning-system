//
//  LocationServicesManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import MapKit

class LocationServicesManager {
    let locationManager = CLLocationManager()
    var locationManagerDelegate: LocationManagerDelegate!
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAutorization()
            
            locationManagerDelegate = LocationManagerDelegate(locationServicesManager: self)
            locationManager.delegate = locationManagerDelegate
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location Services are Disabled", message: "To endable it go: Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    func checkLocationAutorization() {
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                break
            case .denied:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showAlert(title: "Location Services are denied", message: "To enable your location tracking: Setting -> MyPlaces -> Location")
                }
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                break
            case .authorizedAlways:
                break
            @unknown default:
                print("New cases was added")
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
