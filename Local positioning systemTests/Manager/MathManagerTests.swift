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
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
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
}
