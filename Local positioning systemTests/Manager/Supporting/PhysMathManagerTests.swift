//
//  UserManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import XCTest
import CoreLocation
@testable import Local_positioning_system

class PhysMathManagerTests: XCTestCase {
    
    func testCalculateTriangleSidesLength() {
        let first = CGPoint(x: 0, y: 0)
        let second = CGPoint(x: 5, y: 5)
        
        let result = PhysMathManager.calculateTriangleSidesLength(firstPoint: first, secondPoint: second)
        
        XCTAssertEqual(result.x, 5)
        XCTAssertEqual(result.y, 5)
        XCTAssertEqual(result.hypotenuse, sqrt(50))
    }
    
    func testCalculateHypotenuseCalculatesWidth() {
        let firstPoint = CGPoint(x: 0, y: 4)
        let secondPoint = CGPoint(x: 5, y: 0)
        
        let result = PhysMathManager.calculateHypotenuse(firstPoint: firstPoint, secondPoint: secondPoint)
        
        XCTAssertEqual(result, sqrt(41))
    }
    
    func testCalculatePercentWorksCorrectly() {
        let of = 3.5
        let from = 7.0
        
        let result = PhysMathManager.calculatePercent(ofNumber: of, fromHundredPercentNumber: from)
        
        XCTAssertEqual(result, 50)
    }
    
    func testCalculateNumberWorksCorrectly() {
        let ofPercent = 44.0
        let number = 1400.0
        
        let result = PhysMathManager.calculateNumber(lowerPercent: ofPercent, highterNumber: number)
        
        XCTAssertEqual(result, 616)
    }
    
    func testRotatePointWorksCorrectly() {
        // При нуле алгоритмика ломается
        
        let point = CGPoint(x: 2, y: 4)
        let sp = CGPoint(x: 4, y: 0.1)

        let ySide = point.y - sp.y
        let h = PhysMathManager.calculateHypotenuse(firstPoint: point, secondPoint: sp)
        
        let angle = PhysMathManager.getAngle(oppositeCathet: ySide, hypotenuse: h)

        let result = PhysMathManager.rotatePoint(pointToRotate: point, centerPoint: sp, angleInDegrees: angle)

        XCTAssertEqual(result.x, -0.38292140016222476)
        XCTAssertEqual(result.y, 0.10000000000000112)
    }
    
    func testRotatePointWorksCorrectly2() {
        let a = CGPoint(x: 0, y: 3)
        let b = CGPoint(x: 1, y: 4)
        let c = CGPoint(x: 4, y: 2)
        let d = CGPoint(x: 3, y: 1)

        let adY = a.y - d.y
        let adH = PhysMathManager.calculateHypotenuse(firstPoint: a, secondPoint: d)
        let angle = PhysMathManager.getAngle(oppositeCathet: adY, hypotenuse: adH)
        
        let newA = PhysMathManager.rotatePoint(pointToRotate: a, centerPoint: d, angleInDegrees: angle)
        
        let newB = PhysMathManager.rotatePoint(pointToRotate: b, centerPoint: d, angleInDegrees: angle)
        
        let newC = PhysMathManager.rotatePoint(pointToRotate: c, centerPoint: d, angleInDegrees: angle)
        
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

        let sin = PhysMathManager.getAngle(oppositeCathet: oc, hypotenuse: h)
        let cos = PhysMathManager.getAngle(oppositeCathet: ac, hypotenuse: h)

        XCTAssertEqual(sin, 53.13010235415598)
        XCTAssertEqual(cos, 36.86989764584402)
    }
    
    func testRotateYawWorksCorrectlyWithPositiveValue() {
        let yaw = 0.75
        let angle = 45.0
        
        let result = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        XCTAssertEqual(1.5, result)
    }
    
    func testRotateYawWorksCorrectlyWithNegativeValue() {
        let yaw = -0.75
        let angle = 45.0
        
        let result = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        XCTAssertEqual(-1.5, result)
    }
    
    func testGetNewPointValueWorksCorrectly() {
        let initialP = 0.0
        let initialSpeed = 0.0
        let time = 1.0
        let acceleration = 10.0
        
        let result = PhysMathManager.getNewPointValue(initialP: initialP, initialSpeed: initialSpeed, time: time, acceleration: acceleration)
        
        XCTAssertEqual(result, 5)
    }
    
    func testGetSpeedWorksCorrectly() {
        let initialSpeed = 0.0
        let acceleration = 0.5
        let time = 1.0
        
        let result = PhysMathManager.getSpeed(initialSpeed: initialSpeed, acceleration: acceleration, time: time)
        
        XCTAssertEqual(result, 0.5)
    }
    
    func testCalculateIntersectionPointWorksCorrectly() {
        let res = PhysMathManager.calculateIntersectionPoint(p0_x: 0,
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
