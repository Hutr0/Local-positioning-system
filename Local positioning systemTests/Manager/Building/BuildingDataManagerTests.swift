//
//  BuildingDataManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 22.05.2022.
//

import XCTest
@testable import Local_positioning_system

class BuildingDataManagerTests: XCTestCase {

    var sut: BuildingDataManager!
    
    override func setUpWithError() throws {
        sut = BuildingDataManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetCoordinatesFromPlistReturnsArrayOfCoordinate() {
        var result = sut.getCoordinatesFromPlist(of: .coordinates)
        
        XCTAssertFalse(result.isEmpty)
        
        result = sut.getCoordinatesFromPlist(of: .area)
        
        XCTAssertFalse(result.isEmpty)
    }
}
