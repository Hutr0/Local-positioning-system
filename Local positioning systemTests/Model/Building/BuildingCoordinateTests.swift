//
//  BuildingCoordinateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

class BuildingCoordinateTests: XCTestCase {
    
    var sut: BuildingCoordinates!

    override func setUpWithError() throws {
        sut = BuildingCoordinates()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInit() {
        let lb = CLLocationCoordinate2D(latitude: 55.6725759185084336, longitude: 37.478279674560135)
        let lt = CLLocationCoordinate2D(latitude: 55.67301506732467, longitude: 37.478791533281635)
        let rb = CLLocationCoordinate2D(latitude: 55.6718141891654276, longitude: 37.47903792110716)
        let rt = CLLocationCoordinate2D(latitude: 55.67225333798167, longitude: 37.47954977982864)
        let e = CLLocationCoordinate2D(latitude: 55.67219200458108, longitude: 37.4788591774319)
        
        XCTAssertEqual(sut.leftBottom.longitude, lb.longitude)
        XCTAssertEqual(sut.leftTop.longitude, lt.longitude)
        XCTAssertEqual(sut.rightBottom.longitude, rb.longitude)
        XCTAssertEqual(sut.rightTop.longitude, rt.longitude)
        XCTAssertEqual(sut.enter.longitude, e.longitude)
        
        XCTAssertEqual(sut.leftBottom.latitude, lb.latitude)
        XCTAssertEqual(sut.leftTop.latitude, lt.latitude)
        XCTAssertEqual(sut.rightBottom.latitude, rb.latitude)
        XCTAssertEqual(sut.rightTop.latitude, rt.latitude)
        XCTAssertEqual(sut.enter.latitude, e.latitude)
    }
}
