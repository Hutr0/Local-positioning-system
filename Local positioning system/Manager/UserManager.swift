//
//  UserManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import UIKit
import CoreLocation

class UserManager {
    lazy var buildingCoordinate = BuildingCoordinate()
    
    func getUserCoordinatesForMap(mapWidth: CGFloat, mapHeight: CGFloat, coordinates: CLLocationCoordinate2D) -> CGPoint {
        
        let maxX = buildingCoordinate.rightTop.longitude
        let minX = buildingCoordinate.leftBottom.longitude
        let maxY = buildingCoordinate.leftTop.latitude
        let minY = buildingCoordinate.rightBottom.latitude
        
        let width = MathManager.calculateHypotenuse(firstPoint: CGPoint(x: buildingCoordinate.leftBottom.longitude,
                                                            y: buildingCoordinate.leftBottom.latitude),
                                        secondPoint: CGPoint(x: buildingCoordinate.rightBottom.longitude,
                                                             y: buildingCoordinate.rightBottom.latitude))
        let height = MathManager.calculateHypotenuse(firstPoint: CGPoint(x: buildingCoordinate.leftBottom.longitude,
                                                             y: buildingCoordinate.leftBottom.latitude),
                                         secondPoint: CGPoint(x: buildingCoordinate.leftTop.longitude,
                                                              y: buildingCoordinate.leftTop.latitude))
        
        let pointToRight = maxX - coordinates.longitude
        let pointToLeft = coordinates.longitude - minX
        let pointToTop = maxY - coordinates.latitude
        let pointToBootom = coordinates.latitude - minY
        
        let percentX = MathManager.calculatePercent(of: pointToLeft, to: width)
        let percentY = MathManager.calculatePercent(of: pointToBootom, to: height)
        
        let pointX = MathManager.calculateSmallerNumber(of: percentX, to: mapWidth)
        let pointY = MathManager.calculateSmallerNumber(of: percentY, to: mapHeight)
        
        return CGPoint(x: pointX, y: pointY)
    }
}
