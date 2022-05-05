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
    let positioningManager = PositioningManager()
    
    var closure: ((CLLocationCoordinate2D) -> ())!
    
    func startGettingLocation(closureIfWeAreInside: @escaping (CLLocationCoordinate2D) -> ()) {
        locationServicesManager.checkLocationServices()
        
        if locationServicesManager.locationManager.authorizationStatus == .authorizedWhenInUse {
            closure = closureIfWeAreInside
            startDetectionGettingInsideArea()
        } else {
            //
            //
            //
        }
    }
    
    func startDetectionGettingInsideArea() {
        timerManager.startTimer(timeInterval: 10) { [weak self] in
            guard let self = self else { return }
            
            self.getCurrentUserLocation() { location in
                let isInside = self.checkGettingInside(in: self.buildingArea, userLocation: location)

                if isInside {
                    self.timerManager.stopTimer()
                    self.startDetectionGettingInsideBuilding()
                }
            }
        }
    }
    
    func startDetectionGettingInsideBuilding() {
        timerManager.startTimer(timeInterval: 1) { [weak self] in
            guard let self = self else { return }
            
            self.getCurrentUserLocation() { location in
                let isInArea = self.checkGettingInside(in: self.buildingArea, userLocation: location)
                if !isInArea {
                    self.timerManager.stopTimer()
                    self.startDetectionGettingInsideArea()
                }
                
                let isInside = self.checkGettingInside(in: self.buildingCoordinate, userLocation: location)
                if isInside {
                    self.timerManager.stopTimer()
                    
                    let closure: ((CLLocation) -> ()) = { loc in
                        self.closure(loc.coordinate)
                        
                        if !self.checkGettingInside(in: self.buildingCoordinate, userLocation: loc) {
                            self.locationServicesManager.locationManager.stopUpdatingLocation()
                            self.positioningManager.positioningMotionManager.stopDeviceMotionUpdate()
                            self.startDetectionGettingInsideBuilding()
                        }
                    }
                    
//                    self.setCompletionToLocationManagerDelegate(completion: completionHandler)
//                    self.locationServicesManager.locationManager.startUpdatingLocation()
                    
                    self.positioningManager.startRecordingMotions(coordinatesOfStart: location, closure: closure)
                }
            }
        }
    }
    
    func checkGettingInside(in coordinates: BuildingProtocol, userLocation: CLLocation) -> Bool {
        let lb = coordinates.leftBottom
        let lt = coordinates.leftTop
        let rb = coordinates.rightBottom
        let rt = coordinates.rightTop
        
        let userLocation = userLocation.coordinate
        
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
    
    func setCompletionToLocationManagerDelegate(completion: @escaping (CLLocation) -> ()) {
        let delegate = locationServicesManager.locationManager.delegate
        guard delegate != nil else { return }
        
        (delegate as! LocationManagerDelegate).completionHandler = completion
    }
    
    func getCurrentUserLocation(completion: @escaping (CLLocation) -> ()) {
        let completion: ((CLLocation) -> ()) = { location in
            completion(location)
        }

        setCompletionToLocationManagerDelegate(completion: completion)

        locationServicesManager.locationManager.requestLocation()
        
//        let coord = CLLocationCoordinate2D(latitude: 55.67240880567305, longitude: 37.47905855501432)
//        completion(coord)
    }
}
