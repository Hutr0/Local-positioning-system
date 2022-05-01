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
    
    func testRotatePointWorksCorrectly2() {
        let a = CGPoint(x: 0, y: 3)
        let b = CGPoint(x: 1, y: 4)
        let c = CGPoint(x: 4, y: 2)
        let d = CGPoint(x: 3, y: 1)

        let adY = a.y - d.y
        let adH = MathManager.calculateHypotenuse(firstPoint: a, secondPoint: d)
        let angle = MathManager.getAngle(oppositeCathet: adY, hypotenuse: adH)
        
        let newA = MathManager.rotatePoint(pointToRotate: a, centerPoint: d, angleInDegrees: angle)
        
        let newB = MathManager.rotatePoint(pointToRotate: b, centerPoint: d, angleInDegrees: angle)
        
        let newC = MathManager.rotatePoint(pointToRotate: c, centerPoint: d, angleInDegrees: angle)
        
        XCTAssertEqual(newA.x, -0.6055512754639891)
        XCTAssertEqual(newA.y, 0.9999999999999998)
        
        XCTAssertEqual(newB.x, -0.32820117735137444)
        XCTAssertEqual(newB.y, 2.3867504905630725)
        
        XCTAssertEqual(newC.x, 3.2773500981126142)
        XCTAssertEqual(newC.y, 2.386750490563073)
    }

    func testCalculateAngleWorksCorrectly() {
        let ac = 6.0
        let oc = 8.0
        let h = 10.0

        let sin = MathManager.getAngle(oppositeCathet: oc, hypotenuse: h)
        let cos = MathManager.getAngle(oppositeCathet: ac, hypotenuse: h)

        XCTAssertEqual(sin, 53.13010235415598)
        XCTAssertEqual(cos, 36.86989764584402)
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
