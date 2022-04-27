//
//  RotationRateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class AttitudeTests: XCTestCase {

    var sut: Attitude!
    
    override func setUpWithError() throws {
        sut = Attitude(first: 1, second: 1, fird: 1)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testAttitudeCorrectlyInit() {
        let newRr = Attitude(first: 2, second: 2, fird: 2)
        
        sut = newRr
        
        XCTAssertEqual(sut.roll, 2)
        XCTAssertEqual(sut.pitch, 2)
        XCTAssertEqual(sut.yaw, 2)
    }
    
    func testAttitudeCorrectlyDeconstruct() {
        let result = sut.deconstruct()
        
        XCTAssertEqual(result[0], 1)
        XCTAssertEqual(result[1], 1)
        XCTAssertEqual(result[2], 1)
    }
}
