//
//  MapViewModel.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import UIKit
import MapKit

class MapManager: MKMapView {
    
    let locationManager = CLLocationManager()
    
    private let regionInMeters = 1000.0
    
    func checkLocationServices(mapView: MKMapView, closure: () -> ()) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAutorization(mapView: mapView)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location Services are Disabled", message: "To endable it go: Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    func checkLocationAutorization(mapView: MKMapView) {
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                showUserLocation(mapView: mapView)
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
    
    func showUserLocation(mapView: MKMapView) {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region, animated: false)
        }
    }
    
    private func showAlert(title: String, message: String) {
        
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

extension MapManager: MKMapViewDelegate {
    
}
