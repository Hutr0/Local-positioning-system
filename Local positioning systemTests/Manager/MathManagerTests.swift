//
//  UserManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import XCTest
import CoreLocation
@testable import Local_positioning_system

class MathManagerTests: XCTestCase {
    
    func testCalculatePercentWorksCorrectly() {
        let of = 3.5
        let to = 7.0
        
        let result = MathManager.calculatePercent(of: of, to: to)
        
        XCTAssertEqual(result, 50)
    }
    
    func testCalculateSmallerNumberWorksCorrectly() {
        let ofPercent = 44.0
        let number = 1400.0
        
        let result = MathManager.calculateSmallerNumber(of: ofPercent, to: number)
        
        XCTAssertEqual(result, 616)
    }
    
    func testCalculateHypotenuseCalculatesWidth() {
        let firstPoint = CGPoint(x: 0, y: 4)
        let secondPoint = CGPoint(x: 5, y: 0)
        
        let result = MathManager.calculateHypotenuse(firstPoint: firstPoint, secondPoint: secondPoint)
        
        XCTAssertEqual(result, sqrt(41))
    }
    
    func testRotatePointWorksCorrectly() {
        // При нуле алгоритмика ломается
        
        let point = CGPoint(x: 2, y: 4)
        let sp = CGPoint(x: 4, y: 0.1)

        let ySide = point.y - sp.y
        let h = MathManager.calculateHypotenuse(firstPoint: point, secondPoint: sp)
        
        let angle = MathManager.getAngle(oppositeCathet: ySide, hypotenuse: h)

        let result = MathManager.rotatePoint(pointToRotate: point, centerPoint: sp, angleInDegrees: angle)

        XCTAssertEqual(result.x, -0.38292140016222476)
        XCTAssertEqual(result.y, 0.10000000000000112)
    }

    func testCalculateAngleBetweenWorksCorrectly() {
        let ac = 6.0
        let oc = 8.0
        let h = 10.0

        let sin = MathManager.getAngle(oppositeCathet: oc, hypotenuse: h)
        let cos = MathManager.getAngle(oppositeCathet: ac, hypotenuse: h)

        XCTAssertEqual(sin, 53.13010235415598)
        XCTAssertEqual(cos, 36.86989764584402)
    }
    
    func testCalculateSidesLengthWorksCorrecly() {
        let fp = CGPoint(x: 0, y: 0)
        let sp = CGPoint(x: 5, y: 10)
        
        let h = MathManager.calculateHypotenuse(firstPoint: fp, secondPoint: sp)
        let x = sp.x - fp.x
        let y = sp.y - fp.y
        
        let result = MathManager.calculateSidesLength(firstPoint: fp, secondPoint: sp)
        
        XCTAssertEqual(h, result.hypotenuse)
        XCTAssertEqual(x, result.x)
        XCTAssertEqual(y, result.y)
    }
    
    func testCalculateIntersectionPointWorksCorrectly() {
        let res = MathManager.calculateIntersectionPoint(p0_x: 0,
                                p0_y: 0,
                                p1_x: 10,
                                p1_y: 10,
                                p2_x: 0,
                                p2_y: 7,
                                p3_x: 7,
                                p3_y: 0)
        
        XCTAssertNotNil(res)
        XCTAssertEqual(res!.x, 3.5)
        XCTAssertEqual(res!.y, 3.5)
    }
}
