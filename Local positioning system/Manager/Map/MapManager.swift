//
//  MapManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import UIKit
import CoreLocation

class MapManager {
    lazy var buildingCoordinates = BuildingManager.shared.buildingCoordinates
    
    lazy var locationServicesManager = LocationServicesManager.shared
    lazy var userManager = UserManager()
    lazy var positioningManager = PositioningManager()
    lazy var gettingInsideManager = GettingInsideManager()
    
    func startGettingLocation(mapWidth: CGFloat, mapHeight: CGFloat, closure: @escaping (CGPoint) -> ()) {
        let completionHandler: ((CGPoint) -> ()) = { [weak self] point in
            guard let self = self else { return }
                        
            if CLLocationManager.locationServicesEnabled() && self.locationManagerAuthorizedWhenInUse() {
                let completion: ((CLLocation) -> ()) = { location in
                    
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    
                    let point = self.userManager.getUserCoordinatesForMap(mapWidth: mapWidth,
                                                                          mapHeight: mapHeight,
                                                                          coordinatesOfUser: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                   
                    closure(point)
                }
                
                self.gettingInsideManager.setCompletionToLocationManagerDelegate(completion: completion)
                self.locationServicesManager.locationManager.startUpdatingLocation()
            } else {
                let pointInMeters = MapManager.convertPointFromMapToMeters(point: point)
                self.positioningManager.startRecordingMotions(pointOfStart: pointInMeters, closure: closure)
            }
        }
        
        checkGettingInside(mapWidth: mapWidth, mapHeight: mapHeight, completionHandler: completionHandler)
    }
    
    func checkGettingInside(mapWidth: CGFloat, mapHeight: CGFloat, completionHandler: @escaping (CGPoint) -> ()) {
        locationServicesManager.checkLocationServices()
        
        if locationManagerAuthorizedWhenInUse() {
            let completionHandler: ((CLLocationCoordinate2D) -> ()) = { [weak self] location in
                guard let self = self else { return }
                
                let latitude = location.latitude
                let longitude = location.longitude
                
                let point = self.userManager.getUserCoordinatesForMap(mapWidth: mapWidth,
                                                                      mapHeight: mapHeight,
                                                                      coordinatesOfUser: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                
                completionHandler(point)
            }
            
            gettingInsideManager.startDetectionGettingInside(completionHandler: completionHandler)
        } else {
            let latitude = buildingCoordinates.enter.latitude
            let longitude = buildingCoordinates.enter.longitude
            
            let point = userManager.getUserCoordinatesForMap(mapWidth: mapWidth,
                                                             mapHeight: mapHeight,
                                                             coordinatesOfUser: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            
            completionHandler(point)
        }
    }
    
    func locationManagerAuthorizedWhenInUse() -> Bool {
        return locationServicesManager.locationManager.authorizationStatus == .authorizedWhenInUse ? true : false
    }
    
    static func convertPointFromMapToMeters(point: CGPoint) -> CGPoint {
        let x = point.x
        let y = point.y
        
        let percentOfX = PhysMathManager.calculatePercent(ofNumber: x, fromHundredPercentNumber: 1460)
        let percentOfY = PhysMathManager.calculatePercent(ofNumber: y, fromHundredPercentNumber: 900)
        
        let newX = PhysMathManager.calculateNumber(lowerPercent: percentOfX, highterNumber: 78.5)
        let newY = PhysMathManager.calculateNumber(lowerPercent: percentOfY, highterNumber: 46)
        
        return CGPoint(x: newX, y: newY)
    }
    
    static func convertPointFromMetersToMap(point: CGPoint) -> CGPoint {
        let x = point.x
        let y = point.y
        
        let percentOfX = PhysMathManager.calculatePercent(ofNumber: x, fromHundredPercentNumber: 78.5)
        let percentOfY = PhysMathManager.calculatePercent(ofNumber: y, fromHundredPercentNumber: 46)
        
        let newX = PhysMathManager.calculateNumber(lowerPercent: percentOfX, highterNumber: 1460)
        let newY = PhysMathManager.calculateNumber(lowerPercent: percentOfY, highterNumber: 900)
        
        return CGPoint(x: newX, y: newY)
    }
}
