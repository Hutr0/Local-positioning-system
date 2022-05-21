//
//  BuildingManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 15.05.2022.
//

import UIKit

class BuildingManager {

    static let shared = BuildingManager()
    
    private init() {}
    
    lazy var buildingCoordinates = BuildingCoordinates()
    lazy var buildingArea = BuildingArea()
    
    func getAngleOfBuilding() -> Double {
        let a = self.getValue(ofPoint: .a, in: .coordinate)
        let d = self.getValue(ofPoint: .d, in: .coordinate)
        
        let sidesLength = PhysMathManager.calculateSidesLength(firstPoint: a, secondPoint: d)
        let angle = PhysMathManager.getAngle(oppositeCathet: sidesLength.y, hypotenuse: sidesLength.hypotenuse)
        
        return angle
    }
    
    func getValue(ofPoint point: BuildingPointName, in type: BuildingType) -> CGPoint {
        var p = CGPoint()
        
        switch type {
        case .coordinate:
            switch point {
            case .a:
                p = CGPoint(x: buildingCoordinates.leftBottom.longitude,
                            y: buildingCoordinates.leftBottom.latitude)
            case .b:
                p = CGPoint(x: buildingCoordinates.leftTop.longitude,
                            y: buildingCoordinates.leftTop.latitude)
            case .c:
                p = CGPoint(x: buildingCoordinates.rightTop.longitude,
                            y: buildingCoordinates.rightTop.latitude)
            case .d:
                p = CGPoint(x: buildingCoordinates.rightBottom.longitude,
                            y: buildingCoordinates.rightBottom.latitude)
            }
        case .area:
            switch point {
            case .a:
                p = CGPoint(x: buildingArea.leftBottom.longitude,
                            y: buildingArea.leftBottom.latitude)
            case .b:
                p = CGPoint(x: buildingArea.leftTop.longitude,
                            y: buildingArea.leftTop.latitude)
            case .c:
                p = CGPoint(x: buildingArea.rightTop.longitude,
                            y: buildingArea.rightTop.latitude)
            case .d:
                p = CGPoint(x: buildingArea.rightBottom.longitude,
                            y: buildingArea.rightBottom.latitude)
            }
        }
        
        return p
    }
}
