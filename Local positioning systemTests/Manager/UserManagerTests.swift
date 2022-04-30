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
    
    func testbuildingCoordinateNotNil() {
        XCTAssertNotNil(sut.buildingCoordinate)
    }
    
    func testGetUserCoordinatesForMapReturnsNotNil() {
        XCTAssertNotNil(sut.getUserCoordinatesForMap(mapWidth: 0, mapHeight: 0, coordinates: CLLocationCoordinate2D()))
    }
    
    func testGetSizeOfBuildingRetursCorrectlyValue() {
        let width = MathManager.calculateHypotenuse(firstPoint: CGPoint(x: sut.buildingCoordinate.leftBottom.longitude,
                                                                        y: sut.buildingCoordinate.leftBottom.latitude),
                                                    secondPoint: CGPoint(x: sut.buildingCoordinate.rightBottom.longitude,
                                                                         y: sut.buildingCoordinate.rightBottom.latitude))
        let height = MathManager.calculateHypotenuse(firstPoint: CGPoint(x: sut.buildingCoordinate.leftBottom.longitude,
                                                                         y: sut.buildingCoordinate.leftBottom.latitude),
                                                     secondPoint: CGPoint(x: sut.buildingCoordinate.leftTop.longitude,
                                                                          y: sut.buildingCoordinate.leftTop.latitude))
        let size = CGSize(width: width, height: height)
        
        let result = sut.getSizeOfBuilding()
        
        XCTAssertEqual(size, result)
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly1() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = CLLocationCoordinate2D(latitude: 55.67252498442427, longitude: 37.47844079363455)
        
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinates: coordinates)
        
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, 0)
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly2() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = CLLocationCoordinate2D(latitude: 55.67224525582763, longitude: 37.47972036203386)
        
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinates: coordinates)
        
        XCTAssertEqual(result.x, 1400)
        XCTAssertEqual(result.y, 900)
    }
    
    func testCalculateSidesLengthWorksCorrecly() {
        let fp = CGPoint(x: 0, y: 0)
        let sp = CGPoint(x: 5, y: 10)
        
        let h = MathManager.calculateHypotenuse(firstPoint: fp, secondPoint: sp)
        let x = sp.x - fp.x
        let y = sp.y - fp.y
        
        let result = sut.calculateSidesLength(firstPoint: fp, secondPoint: sp)
        
        XCTAssertEqual(h, result.hypotenuse)
        XCTAssertEqual(x, result.x)
        XCTAssertEqual(y, result.y)
    }
}
