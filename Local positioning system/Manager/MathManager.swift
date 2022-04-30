//
//  MathManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 29.04.2022.
//

import Foundation
import Accelerate

class MathManager {
    
    static func rotatePoint(pointToRotate: CGPoint, centerPoint: CGPoint, angleInDegrees: Double) -> CGPoint {
        
        let angleInRadians = angleInDegrees * (Double.pi / 180)
        let sinTheta = sin(angleInRadians)
        let cosTheta = cos(angleInRadians)
        
        let x = cosTheta * (pointToRotate.x - centerPoint.x) - sinTheta * (pointToRotate.y - centerPoint.y) + centerPoint.x
        let y = sinTheta * (pointToRotate.x - centerPoint.x) + cosTheta * (pointToRotate.y - centerPoint.y) + centerPoint.y
        
        return CGPoint(x: x, y: y)
    }
    
    static func getAngle(oppositeCathet: Double, hypotenuse: Double) -> Double {
        
        let sinusTypeRelation = oppositeCathet / hypotenuse
        
        let arcsin = asin(sinusTypeRelation) * 180 / Double.pi
        
        return arcsin
    }
    
    static func calculateSidesLength(firstPoint: CGPoint, secondPoint: CGPoint) -> TriangleSides {
        
        let hypotenuse = calculateHypotenuse(firstPoint: firstPoint, secondPoint: secondPoint)
        let x = max(firstPoint.x, secondPoint.x) - min(firstPoint.x, secondPoint.x)
        let y = max(firstPoint.y, secondPoint.y) - min(firstPoint.y, secondPoint.y)
        
        return TriangleSides(x: x, y: y, hypotenuse: hypotenuse)
    }
    
    static func calculatePercent(of number: Double, to hundredPercent: Double) -> Double {
        return (number * 100) / hundredPercent
    }
    
    static func calculateSmallerNumber(of percent: Double, to number: Double) -> Double {
        return (number * percent) / 100
    }
    
    static func calculateHypotenuse(firstPoint: CGPoint, secondPoint: CGPoint) -> Double {
        
        var result: Double
        
        let x = secondPoint.x - firstPoint.x
        let y = secondPoint.y - firstPoint.y
        
        let rightSide = pow(x, 2) + pow(y, 2)
        
        result = sqrt(rightSide)
        
        return result
    }
    
    static func calculateIntersectionPoint(p0_x: Float, p0_y: Float, p1_x: Float, p1_y: Float, p2_x: Float, p2_y: Float, p3_x: Float, p3_y: Float) -> CGPoint? {
        let i_x: Float
        let i_y: Float
        
        var s1_x: Float
        var s1_y: Float
        var s2_x: Float
        var s2_y: Float
        
        s1_x = p1_x - p0_x
        s1_y = p1_y - p0_y
        s2_x = p3_x - p2_x
        s2_y = p3_y - p2_y

        var s: Float
        var t: Float
        
        s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y)
        t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y)

        if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
        {
            i_x = p0_x + (t * s1_x)
            i_y = p0_y + (t * s1_y)
            return CGPoint(x: CGFloat(i_x), y: CGFloat(i_y))
        }

            return nil
    }
}
