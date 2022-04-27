//
//  BuildingCoordinateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

class BuildingAreaTests: XCTestCase {
    
    var sut: BuildingArea!

    override func setUpWithError() throws {
        sut = BuildingArea()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInit() {
        let lb = CLLocationCoordinate2D(latitude: 55.67251976271117, longitude: 37.47807658227939)
        let lt = CLLocationCoordinate2D(latitude: 55.67296292923412, longitude: 37.4790514089806)
        let rb = CLLocationCoordinate2D(latitude: 55.67180389258219, longitude: 37.47907448597416)
        let rt = CLLocationCoordinate2D(latitude: 55.672212965043585, longitude: 37.48000555803723)
        
        XCTAssertEqual(sut.leftBottom.longitude, lb.longitude)
        XCTAssertEqual(sut.leftTop.longitude, lt.longitude)
        XCTAssertEqual(sut.rightBottom.longitude, rb.longitude)
        XCTAssertEqual(sut.rightTop.longitude, rt.longitude)
        
        XCTAssertEqual(sut.leftBottom.latitude, lb.latitude)
        XCTAssertEqual(sut.leftTop.latitude, lt.latitude)
        XCTAssertEqual(sut.rightBottom.latitude, rb.latitude)
        XCTAssertEqual(sut.rightTop.latitude, rt.latitude)
    }
}
