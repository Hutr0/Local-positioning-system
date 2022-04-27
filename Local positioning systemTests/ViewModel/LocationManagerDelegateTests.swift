//
//  LocationManagerDelegateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system

class LocationManagerDelegateTests: XCTestCase {

    var sut: LocationManagerDelegate!

    override func setUpWithError() throws {
        sut = LocationManagerDelegate(locationServicesManager: LocationServicesManager())
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMapManagerNotNilAfterInit() {
        XCTAssertNotNil(sut.locationServicesManager)
    }
}
