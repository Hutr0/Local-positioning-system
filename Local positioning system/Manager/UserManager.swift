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
        
//        let a = CGPoint(x: 0, y: 1)
//        let b = CGPoint(x: 1, y: 2)
//        let c = CGPoint(x: 3, y: 1)
//        let d = CGPoint(x: 2, y: 0)
//        let p = CGPoint(x: 0.5, y: 1)
        
        let sizesLength = calculateSidesLength(firstPoint: a, secondPoint: d)
        let angle = MathManager.getAngle(oppositeCathet: sizesLength.y, hypotenuse: sizesLength.hypotenuse)
        
        let newA = MathManager.rotatePoint(pointToRotate: a, centerPoint: d, angleInDegrees: angle)
        let newB = MathManager.rotatePoint(pointToRotate: b, centerPoint: d, angleInDegrees: angle)
        let newC = MathManager.rotatePoint(pointToRotate: c, centerPoint: d, angleInDegrees: angle)
        let newD = d
        let newP = MathManager.rotatePoint(pointToRotate: p, centerPoint: d, angleInDegrees: angle)
        
        let maxWidth = max(newC.x, newD.x) - min(newA.x, newB.x)
        let minWidth = min(newC.x, newD.x) - max(newA.x, newB.x)
        var maxPercentToTrailing = MathManager.calculatePercent(of: max(newD.x, newC.x) - newP.x, to: maxWidth)
        var minPercentToTrailing = MathManager.calculatePercent(of: min(newD.x, newC.x) - newP.x, to: minWidth)
        
        let maxHeight = max(newB.y, newC.y) - min(newA.y, newD.y)
        let minHeight = min(newB.y, newC.y) - max(newA.y, newD.y)
        var maxPercentToTop = MathManager.calculatePercent(of: max(newB.y, newC.y) - newP.y, to: maxHeight)
        var minPercentToTop = MathManager.calculatePercent(of: min(newB.y, newC.y) - newP.y, to: minHeight)
        
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
        
        let xCoordinatesOnMap = MathManager.calculateSmallerNumber(of: percentFromBeginning, to: mapWidth)
        let yCoordinatesOnMap = MathManager.calculateSmallerNumber(of: percentFromBottom, to: mapHeight)
        
//        let centerTriangleSides = calculateSidesLength(firstPoint: a, secondPoint: d)
//
//        let adAngle = MathManager.getAngle(oppositeCathet: centerTriangleSides.y, hypotenuse: centerTriangleSides.hypotenuse)
//        let newA = MathManager.rotatePoint(pointToRotate: a, centerPoint: d, angleInDegrees: adAngle)
//
//        let bCenter = CGPoint(x: b.x + centerTriangleSides.x, y: b.y - centerTriangleSides.y)
//        let abCenterSides = calculateSidesLength(firstPoint: b, secondPoint: d)
//        let abAngle = MathManager.getAngle(oppositeCathet: abCenterSides.y, hypotenuse: abCenterSides.hypotenuse)
//        let newB = MathManager.rotatePoint(pointToRotate: b, centerPoint: d, angleInDegrees: abAngle - adAngle)
//
//        let cCenter = CGPoint(x: c.x + centerTriangleSides.x, y: c.y - centerTriangleSides.y)
//        let bcCenterSides = calculateSidesLength(firstPoint: c, secondPoint: cCenter)
//        let bcAngle = MathManager.getAngle(oppositeCathet: bcCenterSides.y, hypotenuse: bcCenterSides.hypotenuse)
//        let newC = MathManager.rotatePoint(pointToRotate: c, centerPoint: d, angleInDegrees: adAngle)

//        let cd = calculateSidesLength(firstPoint: c, secondPoint: d)
//        let da = calculateSidesLength(firstPoint: d, secondPoint: a)
//        let dp = calculateSidesLength(firstPoint: d, secondPoint: p)
//
//        let angle = MathManager.getAngle(oppositeCathet: da.y, hypotenuse: da.hypotenuse)
//        let angleCD = MathManager.getAngle(oppositeCathet: cd.y, hypotenuse: cd.hypotenuse)
//        let anglePD = MathManager.getAngle(oppositeCathet: dp.y, hypotenuse: dp.hypotenuse)
//
//        let sides = [calculateSidesLength(firstPoint: p, secondPoint: b), calculateSidesLength(firstPoint: p, secondPoint: d)]
//
//        let newA = MathManager.rotatePoint(pointToRotate: a, centerPoint: d, angleInDegrees: angle)
//        let newC = MathManager.rotatePoint(pointToRotate: c, centerPoint: d, angleInDegrees: angle)
//        let newP = MathManager.rotatePoint(pointToRotate: p, centerPoint: d, angleInDegrees: angle)
//        let newB = MathManager.rotatePoint(pointToRotate: b, centerPoint: d, angleInDegrees: angle)
////        let newB = CGPoint(x: newA.x, y: newC.y)
//        let newD = d
//        let newSides = [calculateSidesLength(firstPoint: newP, secondPoint: newB), calculateSidesLength(firstPoint: newP, secondPoint: newD)]
        
//        let maxX = buildingCoordinate.rightTop.longitude
//        let minX = buildingCoordinate.leftBottom.longitude
//        let maxY = buildingCoordinate.leftTop.latitude
//        let minY = buildingCoordinate.rightBottom.latitude
//
////        let pointToRight = maxX - coordinates.longitude
//        let pointToLeft = coordinates.longitude - minX
////        let pointToTop = maxY - coordinates.latitude
//        let pointToBootom = coordinates.latitude - minY
//
//        let sizeOfRectangle = getSizeOfBuilding()
//
//        let percentX = MathManager.calculatePercent(of: pointToLeft, to: sizeOfRectangle.width)
//        let percentY = MathManager.calculatePercent(of: pointToBootom, to: sizeOfRectangle.height)
//
//        let pointX = MathManager.calculateSmallerNumber(of: percentX, to: mapWidth)
//        let pointY = MathManager.calculateSmallerNumber(of: percentY, to: mapHeight)
        
        return CGPoint(x:xCoordinatesOnMap , y: yCoordinatesOnMap)
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
    
    func calculateSidesLength(firstPoint: CGPoint, secondPoint: CGPoint) -> TriangleSides {
        
        let hypotenuse = MathManager.calculateHypotenuse(firstPoint: firstPoint, secondPoint: secondPoint)
        let x = max(firstPoint.x, secondPoint.x) - min(firstPoint.x, secondPoint.x)
        let y = max(firstPoint.y, secondPoint.y) - min(firstPoint.y, secondPoint.y)
        
        return TriangleSides(x: x, y: y, hypotenuse: hypotenuse)
    }
}
