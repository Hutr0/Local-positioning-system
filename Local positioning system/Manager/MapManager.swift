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
    
    func startGettingLocation(closureIfWeAreInside: @escaping () -> ()) {
        locationServicesManager.checkLocationServices()
        startDetectionGettingInsideArea(closureIfWeAreInside: closureIfWeAreInside)
    }
    
    func startDetectionGettingInsideArea(closureIfWeAreInside: @escaping () -> ()) {
        timerManager.startTimer(timeInterval: 10) { [weak self] in
            guard let self = self else { return }
            
            guard let userLocation = self.locationServicesManager.locationManager.location?.coordinate else { return }
            let isInside = self.checkGettingInside(in: self.buildingArea, userLocation: userLocation)

            if isInside {
                self.timerManager.stopTimer()
                self.startDetectionGettingInsideBuilding(closureIfWeAreInside: closureIfWeAreInside)
            }
        }
    }
    
    func startDetectionGettingInsideBuilding(closureIfWeAreInside: @escaping () -> ()) {
        timerManager.startTimer(timeInterval: 1) { [weak self] in
            guard let self = self else { return }
            
            guard let userLocation = self.locationServicesManager.locationManager.location?.coordinate else { return }
            let isInside = self.checkGettingInside(in: self.buildingCoordinate, userLocation: userLocation)

            if isInside {
                self.timerManager.stopTimer()
                closureIfWeAreInside()
            }
        }
    }
    
    func checkGettingInside(in coordinates: BuildingProtocol, userLocation: CLLocationCoordinate2D) -> Bool {
        let lb = coordinates.leftBottom
        let lt = coordinates.leftTop
        let rb = coordinates.rightBottom
        let rt = coordinates.rightTop
        
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
