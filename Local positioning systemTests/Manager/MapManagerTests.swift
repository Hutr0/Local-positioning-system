//
//  MapManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

class MapManagerTests: XCTestCase {
    
    var sut: MapManager!

    override func setUpWithError() throws {
        sut = MapManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testBuildingCoordinateNotNil() {
        XCTAssertNotNil(sut.buildingCoordinate)
    }
    
    func testBuildingAreaNotNil() {
        XCTAssertNotNil(sut.buildingArea)
    }
    
    func testLocationServicesManagerNotNil() {
        XCTAssertNotNil(sut.locationServicesManager)
    }
    
    func testTimerManagerManagerNotNil() {
        XCTAssertNotNil(sut.timerManager)
    }
    
    func testStartDetectionGettingInsideAreaStartsTimer() {
        sut.startDetectionGettingInsideArea()
        
        XCTAssertNotNil(sut.timerManager.timer)
        XCTAssertTrue(sut.timerManager.timer.isValid)
    }
    
    func testStopDetectionGettingInsideAreaStopTimer() {
        sut.startDetectionGettingInsideArea()
        sut.stopDetectionGettingInsideArea()
        
        XCTAssertFalse(sut.timerManager.timer.isValid)
    }
    
    func testCheckGettingInsideAreaWorksCorrectlyFirstTest() {
        let location = CLLocationCoordinate2D(latitude: 55.67239263212078, longitude: 37.47897356390552)
        
        let result = sut.checkGettingInsideArea(userLocation: location)
        
        XCTAssertTrue(result)
    }
    
    func testCheckGettingInsideAreaWorksCorrectlySecondTest() {
        let location = CLLocationCoordinate2D(latitude: 55.671592512248566, longitude: 37.47835052742039)
        
        let result = sut.checkGettingInsideArea(userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testCheckGettingInsideAreaWorksCorrectlyThirdTest() {
        let location = CLLocationCoordinate2D(latitude: 55.67239761556922, longitude: 37.478390897967074)
        
        let result = sut.checkGettingInsideArea(userLocation: location)
        
        XCTAssertTrue(result)
    }
}
