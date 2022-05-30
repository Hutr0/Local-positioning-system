//
//  BuildingCoordinate.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import Foundation
import CoreLocation

struct BuildingCoordinates: BuildingProtocol {
    let buildingManager = BuildingDataManager()
    
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
        
        let coordinates = buildingManager.getCoordinatesFromPlist(of: .coordinates)
        
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
}
