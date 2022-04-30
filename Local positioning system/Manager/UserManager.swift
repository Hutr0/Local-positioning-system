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
        
//        let lb = CGPoint(x: buildingCoordinate.leftBottom.longitude,
//                         y: buildingCoordinate.leftBottom.latitude)
//        let lt = CGPoint(x: buildingCoordinate.leftTop.longitude,
//                         y: buildingCoordinate.leftTop.latitude)
//        let rt = CGPoint(x: buildingCoordinate.rightTop.longitude,
//                         y: buildingCoordinate.rightTop.latitude)
//        let rb = CGPoint(x: buildingCoordinate.rightBottom.longitude,
//                         y: buildingCoordinate.rightBottom.latitude)
//
//        let lbltSides = MathManager.calculateSidesLength(firstPoint: lb, secondPoint: lt)
//        let ltrtSides = MathManager.calculateSidesLength(firstPoint: lt, secondPoint: rt)
//        let rtrbSides = MathManager.calculateSidesLength(firstPoint: rt, secondPoint: rb)
//        let rblbSides = MathManager.calculateSidesLength(firstPoint: rb, secondPoint: lb)
        
//        let lbltAngles = MathManager.calculateCosAndSinOfTriangleWithSides(adjacentCathet: lbltSides.y, oppositeCathet: lbltSides.x, hypotenuse: lbltSides.hypotenuse)
//        let newLb = MathManager.calculateNewCoordinate(of: lb, sin: lbltAngles.sin, cos: lbltAngles.cos)
//        
//        let ltrtAngles = MathManager.calculateCosAndSinOfTriangleWithSides(adjacentCathet: lbltSides.x, oppositeCathet: lbltSides.y, hypotenuse: lbltSides.hypotenuse)
//        let newLt = MathManager.calculateNewCoordinate(of: lt, sin: ltrtAngles.sin, cos: ltrtAngles.cos)
//
//        print(newLb)
//        print(newLt)
        
        
        
        
        
        
        
        
        
        
        
        let maxX = buildingCoordinate.rightTop.longitude
        let minX = buildingCoordinate.leftBottom.longitude
        let maxY = buildingCoordinate.leftTop.latitude
        let minY = buildingCoordinate.rightBottom.latitude
        
//        let pointToRight = maxX - coordinates.longitude
        let pointToLeft = coordinates.longitude - minX
//        let pointToTop = maxY - coordinates.latitude
        let pointToBootom = coordinates.latitude - minY
        
        let sizeOfRectangle = getSizeOfBuilding()
        
        let percentX = MathManager.calculatePercent(of: pointToLeft, to: sizeOfRectangle.width)
        let percentY = MathManager.calculatePercent(of: pointToBootom, to: sizeOfRectangle.height)
        
        let pointX = MathManager.calculateSmallerNumber(of: percentX, to: mapWidth)
        let pointY = MathManager.calculateSmallerNumber(of: percentY, to: mapHeight)
        
        return CGPoint(x: pointX, y: pointY)
    }
    
    func getSizeOfBuilding() -> CGSize {
        let width = MathManager.calculateHypotenuse(firstPoint: CGPoint(x: buildingCoordinate.leftBottom.longitude,
                                                                        y: buildingCoordinate.leftBottom.latitude),
                                                    secondPoint: CGPoint(x: buildingCoordinate.rightBottom.longitude,
                                                                         y: buildingCoordinate.rightBottom.latitude))
        let height = MathManager.calculateHypotenuse(firstPoint: CGPoint(x: buildingCoordinate.leftBottom.longitude,
                                                                         y: buildingCoordinate.leftBottom.latitude),
                                                     secondPoint: CGPoint(x: buildingCoordinate.leftTop.longitude,
                                                                          y: buildingCoordinate.leftTop.latitude))
        return CGSize(width: width, height: height)
    }
}
