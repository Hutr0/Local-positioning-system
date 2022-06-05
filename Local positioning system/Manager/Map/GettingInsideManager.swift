//
//  GettingInsideManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 14.05.2022.
//

import Foundation
import CoreLocation

class GettingInsideManager {
    
    lazy var locationServicesManager = LocationServicesManager.shared
    lazy var buildingCoordinates = BuildingCoordinates()
    
    func startDetectionGettingInside(completionHandler: @escaping (CLLocationCoordinate2D) -> ()) {
        let completion: ((CLLocation) -> ()) = { [weak self] location in
            guard let self = self else { return }
            
            let isInside = self.checkGettingInside(in: self.buildingCoordinates, userLocation: location.coordinate)
                
            if isInside {
                self.locationServicesManager.locationManager.stopUpdatingLocation()
                completionHandler(location.coordinate)
            }
        }
        
        setCompletionToLocationManagerDelegate(completion: completion)
        locationServicesManager.locationManager.startUpdatingLocation()
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
    
    func setCompletionToLocationManagerDelegate(completion: @escaping (CLLocation) -> ()) {
        let delegate = locationServicesManager.locationManager.delegate
        guard delegate != nil else { return }
        
        (delegate as! LocationManagerDelegate).completionHandler = completion
    }
}
