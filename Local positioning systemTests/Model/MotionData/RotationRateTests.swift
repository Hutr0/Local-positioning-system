//
//  RotationRateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class RotationRateTests: XCTestCase {

    var sut: RotationRate!
    
    override func setUpWithError() throws {
        sut = RotationRate(first: 1, second: 1, fird: 1)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testRotationRateCorrectlyInit() {
        let newRr = RotationRate(first: 2, second: 2, fird: 2)
        
        sut = newRr
        
        XCTAssertEqual(sut.x, 2)
        XCTAssertEqual(sut.y, 2)
        XCTAssertEqual(sut.z, 2)
    }
    
    func testRotationRateCorrectlyDeconstruct() {
        let result = sut.deconstruct()
        
        XCTAssertEqual(result[0], 1)
        XCTAssertEqual(result[1], 1)
        XCTAssertEqual(result[2], 1)
    }
}
