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
    
    func testPositioningManagerNotNil() {
        XCTAssertNotNil(sut.positioningManager)
    }
    
    func testBuildingCoordinateNotNil() {
        XCTAssertNotNil(sut.buildingCoordinates)
    }
    
    func testLocationServicesManagerNotNil() {
        XCTAssertNotNil(sut.locationServicesManager)
    }
    
    func testUserManagerManagerNotNil() {
        XCTAssertNotNil(sut.userManager)
    }
    
    func testGettingInsideManagerManagerNotNil() {
        XCTAssertNotNil(sut.gettingInsideManager)
    }
    
    func testStartGettingLocationCallsCheckGettingInside() {
        sut = MockMapManagerFirst()
        
        sut.startGettingLocation(mapWidth: 0, mapHeight: 0, closure: {_ in})
        
        XCTAssertTrue((sut as! MockMapManagerFirst).isInside)
    }
    
    func testStartGettingLocationCallsCompletion() {
        sut = MockMapManagerSecond()
        sut.positioningManager = MockPositioningManager()
        
        sut.startGettingLocation(mapWidth: 0, mapHeight: 0, closure: {_ in})
        
        XCTAssertTrue((sut.positioningManager as! MockPositioningManager).isInside)
    }
    
    func testLocationManagerAuthorizedWhenInUse() {
        let result = sut.locationServicesManager.locationManager.authorizationStatus == .authorizedWhenInUse ? true : false
        
        XCTAssertEqual(sut.locationManagerAuthorizedWhenInUse(), result)
    }
    
    func testCheckGettingInsideCallsCompletion() {
        sut.gettingInsideManager = MockGettingInsideManager()
        var isInside = false

        sut.checkGettingInside(mapWidth: 0, mapHeight: 0, completionHandler: {_ in
            isInside = true
        })
        
        XCTAssertTrue(isInside)
    }
}

extension MapManagerTests {
    class MockMapManagerFirst: MapManager {
        var isInside = false
        
        override func checkGettingInside(mapWidth: CGFloat, mapHeight: CGFloat, completionHandler: @escaping (CGPoint) -> ()) {
            isInside = true
        }
    }
    
    class MockMapManagerSecond: MapManager {
        var isInside = false
        
        override func checkGettingInside(mapWidth: CGFloat, mapHeight: CGFloat, completionHandler: @escaping (CGPoint) -> ()) {
            completionHandler(CGPoint())
        }
    }
    
    class MockPositioningManager: PositioningManager {
        var isInside = false
        
        override func startRecordingMotions(pointOfStart: CGPoint, closure: @escaping (CGPoint) -> ()) {
            isInside = true
        }
    }
    
    class MockGettingInsideManager: GettingInsideManager {
        override func startDetectionGettingInside(completionHandler: @escaping (CLLocationCoordinate2D) -> ()) {
            completionHandler(CLLocationCoordinate2D())
        }
    }
}