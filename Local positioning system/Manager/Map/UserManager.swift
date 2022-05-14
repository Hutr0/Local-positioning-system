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
        
        let a = bm.getValue(ofPoint: .a, in: .coordinate)
        let b = bm.getValue(ofPoint: .b, in: .coordinate)
        let c = bm.getValue(ofPoint: .c, in: .coordinate)
        let d = bm.getValue(ofPoint: .d, in: .coordinate)
        let p = CGPoint(x: coordinatesOfUser.longitude, y: coordinatesOfUser.latitude)
        
        let angle = bm.getAngleOfBuilding()
        
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
}
