//
//  BuildingCoordinate.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation

struct BuildingCoordinate {
    var leftBottom: CLLocationCoordinate2D
    var leftTop: CLLocationCoordinate2D
    var rightBottom: CLLocationCoordinate2D
    var rightTop: CLLocationCoordinate2D
    var enter: CLLocationCoordinate2D
    
    init() {
        leftBottom = CLLocationCoordinate2D()
        leftTop = CLLocationCoordinate2D()
        rightBottom = CLLocationCoordinate2D()
        rightTop = CLLocationCoordinate2D()
        enter = CLLocationCoordinate2D()
        
        let coordinates = getCoordinatesFromPlist()
        
        if !coordinates.isEmpty {
            for coordinate in coordinates {
                switch coordinate.key {
                case "Left bottom":
                    self.leftBottom = coordinate.value
                case "Left top":
                    self.leftTop = coordinate.value
                case "Right bottom":
                    self.rightBottom = coordinate.value
                case "Right top":
                    self.rightTop = coordinate.value
                case "Enter":
                    self.enter = coordinate.value
                default:
                    print("Unexpected value on initialization BuildingCoordinate")
                }
            }
        }
    }
    
    func getCoordinatesFromPlist() -> [String: CLLocationCoordinate2D] {
        
        guard let path = Bundle.main.path(forResource: "Data", ofType: "plist") else { return [:] }
        guard let dictionary = NSDictionary(contentsOfFile: path) else { return [:] }
        guard let arrayOfBuildingCoordinate = dictionary.object(forKey: "Building coordinate") as? [String: NSDictionary] else { return [:] }
        
        var coordinates: [String: CLLocationCoordinate2D] = [:]
        
        for coordinate in arrayOfBuildingCoordinate {
            let key = coordinate.key
            
            guard let dic = coordinate.value as? [String : String],
                  let value = getCoordinate(coordinate: dic) else { return [:] }
            
            coordinates[key] = value
        }
        
        return coordinates
    }
    
    func getCoordinate(coordinate: [String: String]) -> CLLocationCoordinate2D? {
        guard let latitude = coordinate["latitude"],
              let longitude = coordinate["longitude"],
              let dLatitude = Double(latitude),
              let dLongitude = Double(longitude) else { return nil }
        return CLLocationCoordinate2D(latitude: dLatitude, longitude: dLongitude)
    }
}
