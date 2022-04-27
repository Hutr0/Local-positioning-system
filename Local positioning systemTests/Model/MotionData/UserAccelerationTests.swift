//
//  RotationRateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class UserAccelerationTests: XCTestCase {

    var sut: UserAcceleration!
    
    override func setUpWithError() throws {
        sut = UserAcceleration(x: 1, y: 1, z: 1)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testUserAccelerationCorrectlyInit() {
        let newRr = UserAcceleration(first: 2, second: 2, fird: 2)
        
        sut = newRr
        
        XCTAssertEqual(sut.x, 2)
        XCTAssertEqual(sut.y, 2)
        XCTAssertEqual(sut.z, 2)
    }
    
    func testUserAccelerationCorrectlyDeconstruct() {
        let result = sut.deconstruct()
        
        XCTAssertEqual(result[0], 1)
        XCTAssertEqual(result[1], 1)
        XCTAssertEqual(result[2], 1)
    }
}
