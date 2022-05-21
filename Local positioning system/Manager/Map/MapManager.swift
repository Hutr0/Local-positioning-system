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
            
            self.positioningManager.startRecordingMotions(pointOfStart: point, closure: closure)
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
}
