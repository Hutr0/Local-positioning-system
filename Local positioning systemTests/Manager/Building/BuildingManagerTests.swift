//
//  BuildingManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system

class BuildingManagerTests: XCTestCase {

    var sut: BuildingManager!
    
    override func setUpWithError() throws {
        sut = BuildingManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testBuildingCoordinatesNotNil() {
        XCTAssertNotNil(sut.buildingCoordinates)
    }
    
    func testBuildingAreaNotNil() {
        XCTAssertNotNil(sut.buildingArea)
    }
    
    func testGetAngleOfBuildingWorksCorrectly() {
        let a = sut.buildingCoordinates.leftBottom
        let d = sut.buildingCoordinates.rightBottom
        let sides = PhysMathManager.calculateTriangleSidesLength(firstPoint: CGPoint(x: a.longitude, y: a.latitude), secondPoint: CGPoint(x: d.longitude, y: d.latitude))
        let angle = PhysMathManager.getAngle(oppositeCathet: sides.y, hypotenuse: sides.hypotenuse)
        
        let result = sut.getAngleOfBuilding()
        
        XCTAssertEqual(angle, result)
    }
    
    func testGetValueOfLeftBottomCoordinatesWorksCorrectly() {
        let value = sut.buildingCoordinates.leftBottom
        
        let result = sut.getValue(ofPoint: .a, in: .coordinates)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
    
    func testGetValueOfLeftTopCoordinatesWorksCorrectly() {
        let value = sut.buildingCoordinates.leftTop
        
        let result = sut.getValue(ofPoint: .b, in: .coordinates)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
    
    func testGetValueOfRightBottomCoordinatesWorksCorrectly() {
        let value = sut.buildingCoordinates.rightBottom
        
        let result = sut.getValue(ofPoint: .d, in: .coordinates)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
    
    func testGetValueOfRightTopCoordinatesWorksCorrectly() {
        let value = sut.buildingCoordinates.rightTop
        
        let result = sut.getValue(ofPoint: .c, in: .coordinates)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
    
    func testGetValueOfLeftBottomAreaWorksCorrectly() {
        let value = sut.buildingArea.leftBottom
        
        let result = sut.getValue(ofPoint: .a, in: .area)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
    
    func testGetValueOfLeftTopAreaWorksCorrectly() {
        let value = sut.buildingArea.leftTop
        
        let result = sut.getValue(ofPoint: .b, in: .area)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
    
    func testGetValueOfRightBottomAreaWorksCorrectly() {
        let value = sut.buildingArea.rightBottom
        
        let result = sut.getValue(ofPoint: .d, in: .area)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
    
    func testGetValueOfRightTopAreaWorksCorrectly() {
        let value = sut.buildingArea.rightTop
        
        let result = sut.getValue(ofPoint: .c, in: .area)
        
        XCTAssertEqual(result.x, value.longitude)
        XCTAssertEqual(result.y, value.latitude)
    }
}
