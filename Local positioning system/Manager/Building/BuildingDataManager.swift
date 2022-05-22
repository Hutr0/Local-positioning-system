//
//  BuildingManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation

class BuildingDataManager {
    func getCoordinatesFromPlist(of buildingType: BuildingType) -> [String: CLLocationCoordinate2D] {
        
        guard let path = Bundle.main.path(forResource: "Data", ofType: "plist") else { return [:] }
        guard let dictionary = NSDictionary(contentsOfFile: path) else { return [:] }
        
        var type: String
        switch buildingType {
        case .coordinates:
            type = "Building coordinate"
        case .area:
            type = "Area coordinate"
        }
        
        guard let arrayOfBuildingCoordinate = dictionary.object(forKey: type) as? [String: NSDictionary] else { return [:] }
        
        var coordinates: [String: CLLocationCoordinate2D] = [:]
        
        for coordinate in arrayOfBuildingCoordinate {
            let key = coordinate.key
            
            guard let dic = coordinate.value as? [String : String],
                  let value = getCoordinate(coordinate: dic) else { return [:] }
            
            coordinates[key] = value
        }
        
        return coordinates
    }
    
    private func getCoordinate(coordinate: [String: String]) -> CLLocationCoordinate2D? {
        guard let latitude = coordinate["latitude"],
              let longitude = coordinate["longitude"],
              let dLatitude = Double(latitude),
              let dLongitude = Double(longitude) else { return nil }
        return CLLocationCoordinate2D(latitude: dLatitude, longitude: dLongitude)
    }
}
