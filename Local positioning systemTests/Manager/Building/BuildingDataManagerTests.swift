//
//  BuildingManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
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
        var result = sut.getCoordinatesFromPlist(of: .coordinate)
        
        XCTAssertFalse(result.isEmpty)
        
        result = sut.getCoordinatesFromPlist(of: .area)
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testGetCoordinateReturnsCorreclyResult() {
        let dictionary = ["latitude": "11.1", "longitude": "22.2"]
        
        let result = sut.getCoordinate(coordinate: dictionary)
        
        XCTAssertEqual(Double(dictionary["latitude"]!), result!.latitude)
        XCTAssertEqual(Double(dictionary["longitude"]!), result!.longitude)
    }
}
