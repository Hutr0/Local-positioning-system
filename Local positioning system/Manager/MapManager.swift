//
//  MapManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import UIKit
import CoreLocation

class MapManager {
    lazy var buildingCoordinates = BuildingCoordinate()
    lazy var buildingArea = BuildingArea()
    
    lazy var locationServicesManager = LocationServicesManager()
    lazy var userManager = UserManager()
    lazy var positioningManager = PositioningManager()
    lazy var gettingInsideManager = GettingInsideManager()
    
    func locationManagerAuthorizedWhenInUse() -> Bool {
        return locationServicesManager.locationManager.authorizationStatus == .authorizedWhenInUse ? true : false
    }
    
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
                
                let latitude = self.buildingCoordinates.enter.latitude
                let longitude = self.buildingCoordinates.enter.longitude
                
                let point = self.userManager.getUserCoordinatesForMap(mapWidth: mapWidth,
                                                                 mapHeight: mapHeight,
                                                                 coordinatesOfUser: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                                                      coordinatesOfBuilding: self.buildingCoordinates)
                
                completionHandler(point)
            }
            
            gettingInsideManager.startDetectionGettingInsideArea(completionHandler: completionHandler)
        } else {
            let latitude = buildingCoordinates.enter.latitude
            let longitude = buildingCoordinates.enter.longitude
            
            let point = userManager.getUserCoordinatesForMap(mapWidth: mapWidth,
                                                             mapHeight: mapHeight,
                                                             coordinatesOfUser: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                                             coordinatesOfBuilding: buildingCoordinates)
            
            completionHandler(point)
        }
    }
}
