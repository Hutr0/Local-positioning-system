//
//  UserManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import UIKit
import CoreLocation

class UserManager {
    func getUserCoordinatesForMap(mapWidth: CGFloat, mapHeight: CGFloat, coordinatesOfUser: CLLocationCoordinate2D) -> CGPoint {
        
        let bm = BuildingManager.shared
        
        let a = bm.getValue(ofPoint: .a, in: .coordinates)
        let b = bm.getValue(ofPoint: .b, in: .coordinates)
        let c = bm.getValue(ofPoint: .c, in: .coordinates)
        let d = bm.getValue(ofPoint: .d, in: .coordinates)
        let p = CGPoint(x: coordinatesOfUser.longitude, y: coordinatesOfUser.latitude)
        
        let angle = bm.getAngleOfBuilding()
        
        let newA = PhysMathManager.rotatePoint(pointToRotate: a, centerPoint: d, angleInDegrees: angle)
        let newB = PhysMathManager.rotatePoint(pointToRotate: b, centerPoint: d, angleInDegrees: angle)
        let newC = PhysMathManager.rotatePoint(pointToRotate: c, centerPoint: d, angleInDegrees: angle)
        let newD = d
        let newP = PhysMathManager.rotatePoint(pointToRotate: p, centerPoint: d, angleInDegrees: angle)
        
        let maxWidth = max(newC.x, newD.x) - min(newA.x, newB.x)
        let minWidth = min(newC.x, newD.x) - max(newA.x, newB.x)
        var maxPercentToTrailing = PhysMathManager.calculatePercent(ofNumber: max(newD.x, newC.x) - newP.x, fromHundredPercentNumber: maxWidth)
        var minPercentToTrailing = PhysMathManager.calculatePercent(ofNumber: min(newD.x, newC.x) - newP.x, fromHundredPercentNumber: minWidth)

        let maxHeight = max(newB.y, newC.y) - min(newA.y, newD.y)
        let minHeight = min(newB.y, newC.y) - max(newA.y, newD.y)
        var maxPercentToTop = PhysMathManager.calculatePercent(ofNumber: max(newB.y, newC.y) - newP.y, fromHundredPercentNumber: maxHeight)
        var minPercentToTop = PhysMathManager.calculatePercent(ofNumber: min(newB.y, newC.y) - newP.y, fromHundredPercentNumber: minHeight)
        
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
//        let percentFromTop = 100 - percentToTop

        let xCoordinatesOnMap = PhysMathManager.calculateNumber(lowerPercent: percentFromBeginning, highterNumber: mapWidth)
        let yCoordinatesOnMap = PhysMathManager.calculateNumber(lowerPercent: percentToTop, highterNumber: mapHeight)

        return CGPoint(x:xCoordinatesOnMap , y: yCoordinatesOnMap)
        
//        return CGPoint()
    }
    
//    func getHeight(minPoint: CGPoint, maxPoint: CGPoint, point: CGPoint, leftPoint: CGPoint, rightPoint: CGPoint) -> Double {
//        let d = max(leftPoint.y, rightPoint.y) - min(leftPoint.y, rightPoint.y)
//
//        let percentFromPToMax = PhysMathManager.calculatePercent(ofNumber: maxPoint.x - point.x, fromHundredPercentNumber: maxPoint.x - minPoint.x)
//
//        let y = min(leftPoint.y, rightPoint.y) + (d / 100 * percentFromPToMax)
//        let x = (rightPoint.x - leftPoint.x) / 100 * percentFromPToMax
//
//        return PhysMathManager.calculateHypotenuse(firstPoint: point, secondPoint: CGPoint(x: x, y: y))
//    }
//
//    func getParameter(pointToSide: Double, pointNotToSide: Double,
//                      minDistanceToSide minDTS: Double, maxDistanceToSide maxDTS: Double,
//                      minDistanceNotToSide minDNTS: Double, maxDistanceNotToSide maxDNTS: Double,
//                      nearestPointNotToSide: Double) -> Double {
//        let difference = getDifferenceBetween(firstPoint: maxDNTS, secondPoint:                       nearestPointNotToSide)
//        let pNotToSide = pointNotToSide - difference
//
//        let pDistanceNotToSide = max(maxDNTS, minDNTS) - pNotToSide
//        let distanceNotToSide = max(maxDNTS, minDNTS) - min(maxDNTS, minDNTS)
//
//        let percentMinDNTSToMaxDNTS = PhysMathManager.calculatePercent(ofNumber: pDistanceNotToSide, fromHundredPercentNumber: distanceNotToSide)
//
//        let distanceToSide = max(maxDTS, minDTS) - min(maxDTS, minDTS)
//
//        let minDTSToMaxDTS = PhysMathManager.calculateNumber(lowerPercent: percentMinDNTSToMaxDNTS, highterNumber: distanceToSide)
//
//        return minDTS - pointToSide + minDTSToMaxDTS
//    }
//
//    func getDifferenceBetween(firstPoint fp: Double, secondPoint sp: Double) -> Double {
//        let max = max(fp, sp)
//        let min = min(fp, sp)
//
//        return max - min
//    }
}
