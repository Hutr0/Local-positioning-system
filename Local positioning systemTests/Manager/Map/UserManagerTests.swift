//
//  UserManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import XCTest
import CoreLocation
@testable import Local_positioning_system

class UserManagerTests: XCTestCase {

    var sut: UserManager!
    
    override func setUpWithError() throws {
        sut = UserManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetUserCoordinatesForMapReturnsNotNil() {
        XCTAssertNotNil(sut.getUserCoordinatesForMap(mapWidth: 0, mapHeight: 0, coordinatesOfUser: CLLocationCoordinate2D()))
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly1() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = BuildingCoordinates().rightTop
        
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinatesOfUser: coordinates)
        
        XCTAssertGreaterThanOrEqual(result.x, mapWidth - 5)
        XCTAssertGreaterThanOrEqual(result.y, mapHeight - 5)
        XCTAssertLessThanOrEqual(result.x, mapWidth)
        XCTAssertLessThanOrEqual(result.y, mapHeight)
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly2() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = BuildingCoordinates().leftBottom
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinatesOfUser: coordinates)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.x, 5)
        XCTAssertLessThanOrEqual(result.y, 5)
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly3() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = CLLocationCoordinate2D(latitude: 55.67239468839017, longitude: 37.47906302533583)
        
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinatesOfUser: coordinates)
        
        XCTAssertEqual(result.x, 684.4382951208179)
        XCTAssertEqual(result.y, 444.47277675042284)
    }
}
