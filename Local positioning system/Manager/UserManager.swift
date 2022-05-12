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
        
        let a = CGPoint(x: buildingCoordinate.leftBottom.longitude,
                         y: buildingCoordinate.leftBottom.latitude)
        let b = CGPoint(x: buildingCoordinate.leftTop.longitude,
                         y: buildingCoordinate.leftTop.latitude)
        let c = CGPoint(x: buildingCoordinate.rightTop.longitude,
                         y: buildingCoordinate.rightTop.latitude)
        let d = CGPoint(x: buildingCoordinate.rightBottom.longitude,
                         y: buildingCoordinate.rightBottom.latitude)
        let p = CGPoint(x: coordinates.longitude, y: coordinates.latitude)
        
        let sidesLength = calculateSidesLength(firstPoint: a, secondPoint: d)
        let angle = PhysMathManager.getAngle(oppositeCathet: sidesLength.y, hypotenuse: sidesLength.hypotenuse)
        
        let newA = PhysMathManager.rotatePoint(pointToRotate: a, centerPoint: d, angleInDegrees: angle)
        let newB = PhysMathManager.rotatePoint(pointToRotate: b, centerPoint: d, angleInDegrees: angle)
        let newC = PhysMathManager.rotatePoint(pointToRotate: c, centerPoint: d, angleInDegrees: angle)
        let newD = d
        let newP = PhysMathManager.rotatePoint(pointToRotate: p, centerPoint: d, angleInDegrees: angle)
        
        let maxWidth = max(newC.x, newD.x) - min(newA.x, newB.x)
        let minWidth = min(newC.x, newD.x) - max(newA.x, newB.x)
        var maxPercentToTrailing = PhysMathManager.calculatePercent(number: max(newD.x, newC.x) - newP.x, hundredPercentNumber: maxWidth)
        var minPercentToTrailing = PhysMathManager.calculatePercent(number: min(newD.x, newC.x) - newP.x, hundredPercentNumber: minWidth)
        
        let maxHeight = max(newB.y, newC.y) - min(newA.y, newD.y)
        let minHeight = min(newB.y, newC.y) - max(newA.y, newD.y)
        var maxPercentToTop = PhysMathManager.calculatePercent(number: max(newB.y, newC.y) - newP.y, hundredPercentNumber: maxHeight)
        var minPercentToTop = PhysMathManager.calculatePercent(number: min(newB.y, newC.y) - newP.y, hundredPercentNumber: minHeight)
        
        if maxPercentToTrailing > 100 { maxPercentToTrailing = 100 }
        if minPercentToTrailing < 0 { minPercentToTrailing = 0 }
        if maxPercentToTop > 100 { maxPercentToTop = 100 }
        if minPercentToTop < 0 { minPercentToTop = 0 }
        
        var percentToTrailing: Double
        if maxPercentToTrailing != minPercentToTrailing {
            percentToTrailing = (maxPercentToTrailing + minPercentToTrailing) / 2
        } else {
            percentToTrailing = maxPercentToTrailing
        }
        
        var percentToTop: Double
        if maxPercentToTop != minPercentToTop {
            percentToTop = (maxPercentToTop + minPercentToTop) / 2
        } else {
            percentToTop = maxPercentToTop
        }
        
        if percentToTop > 100 { percentToTop = 100 }
        else if percentToTop < 0 { percentToTop = 0 }
        if percentToTrailing > 100 { percentToTrailing = 100 }
        else if percentToTrailing < 0 { percentToTrailing = 0 }
        
        let percentFromBeginning = 100 - percentToTrailing
        let percentFromBottom = 100 - percentToTop
        
        let xCoordinatesOnMap = PhysMathManager.calculateNumberOnPercent(lowerPercent: percentFromBeginning, highterNumber: mapWidth)
        let yCoordinatesOnMap = PhysMathManager.calculateNumberOnPercent(lowerPercent: percentFromBottom, highterNumber: mapHeight)
        
        return CGPoint(x:xCoordinatesOnMap , y: yCoordinatesOnMap)
    }
    
    func calculateSidesLength(firstPoint: CGPoint, secondPoint: CGPoint) -> TriangleSides {
        
        let hypotenuse = PhysMathManager.calculateHypotenuse(firstPoint: firstPoint, secondPoint: secondPoint)
        let x = max(firstPoint.x, secondPoint.x) - min(firstPoint.x, secondPoint.x)
        let y = max(firstPoint.y, secondPoint.y) - min(firstPoint.y, secondPoint.y)
        
        return TriangleSides(x: x, y: y, hypotenuse: hypotenuse)
    }
}
