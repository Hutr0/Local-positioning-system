//
//  MapManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation


class MapManager {
    lazy var buildingCoordinate = BuildingCoordinate()
    lazy var buildingArea = BuildingArea()
    
    let locationServicesManager = LocationServicesManager()
    let timerManager = TimerManager()
    
    func setupLocationServices() {
        locationServicesManager.checkLocationServices()
    }
    
    func startDetectionGettingInsideArea() {
        timerManager.startTimer(timeInterval: 10) {
            guard let userLocation = self.locationServicesManager.locationManager.location?.coordinate else { return }
            let inside = self.checkGettingInsideArea(userLocation: userLocation)

            if !inside { return }
            
            
        }
    }
    
    func checkGettingInsideArea(userLocation: CLLocationCoordinate2D) -> Bool {
        
        let lb = buildingArea.leftBottom
        let lt = buildingArea.leftTop
        let rb = buildingArea.rightBottom
        let rt = buildingArea.rightTop
        
        var isInside = false
        if userLocation.longitude >= lb.longitude &&
            userLocation.longitude <= rt.longitude &&
            userLocation.latitude <= lt.latitude &&
            userLocation.latitude >= rb.latitude {
            isInside = true
        }
        
        return isInside
    }
    
    func stopDetectionGettingInsideArea() {
        timerManager.stopTimer()
    }
}
