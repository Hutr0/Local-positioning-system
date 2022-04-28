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
        
        let p1 = hitCalculate(pointX: userLocation.longitude, pointY: userLocation.latitude,
                              firstX: lb.longitude, firstY: lb.latitude,
                              secondX: lt.longitude, secondY: lt.latitude)
        let p2 = hitCalculate(pointX: userLocation.longitude, pointY: userLocation.latitude,
                              firstX: lt.longitude, firstY: lt.latitude,
                              secondX: rt.longitude, secondY: rt.latitude)
        let p3 = hitCalculate(pointX: userLocation.longitude, pointY: userLocation.latitude,
                              firstX: rt.longitude, firstY: rt.latitude,
                              secondX: rb.longitude, secondY: rb.latitude)
        let p4 = hitCalculate(pointX: userLocation.longitude, pointY: userLocation.latitude,
                              firstX: rb.longitude, firstY: rb.latitude,
                              secondX: lb.longitude, secondY: lb.latitude)
        
        var isInside = false
        if p1 < 0 && p2 < 0 && p3 < 0 && p4 < 0 {
            isInside = true
        }
        
        return isInside
    }
    
    private func hitCalculate(pointX: Double, pointY: Double,
                              firstX: Double, firstY: Double,
                              secondX: Double, secondY: Double) -> Double {
        return (secondX - firstX) * (pointY - firstY) - (secondY - firstY) * (pointX - firstX)
    }
    
    func stopDetectionGettingInsideArea() {
        timerManager.stopTimer()
    }
}
