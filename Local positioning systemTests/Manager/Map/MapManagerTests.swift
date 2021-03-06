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
    
//    func testStartGettingLocationCallsCompletion() {
//        sut = MockMapManagerSecond()
//        sut.positioningManager = MockPositioningManager()
//        
//        sut.startGettingLocation(mapWidth: 0, mapHeight: 0, closure: {_ in})
//        
//        XCTAssertTrue((sut.positioningManager as! MockPositioningManager).isInside)
//    }
    
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
    
    func testConvertPointFromMapToMetersWorksCorrectly() {
        let firstPoint = CGPoint(x: 0, y: 0)
        let secondPoint = CGPoint(x: 1460, y: 900)
        
        let firstPointResult = MapManager.convertPointFromMapToMeters(point: firstPoint)
        let secondPointResult = MapManager.convertPointFromMapToMeters(point: secondPoint)
        
        XCTAssertEqual(firstPointResult.x, 0)
        XCTAssertEqual(firstPointResult.y, 0)
        XCTAssertEqual(secondPointResult.x, 78.5)
        XCTAssertEqual(secondPointResult.y, 46)
    }
    
    func testConvertPointFromMetersToMapWorksCorrectly() {
        let firstPoint = CGPoint(x: 0, y: 0)
        let secondPoint = CGPoint(x: 78.5, y: 46)
        
        let firstPointResult = MapManager.convertPointFromMetersToMap(point: firstPoint)
        let secondPointResult = MapManager.convertPointFromMetersToMap(point: secondPoint)
        
        XCTAssertEqual(firstPointResult.x, 0)
        XCTAssertEqual(firstPointResult.y, 0)
        XCTAssertEqual(secondPointResult.x, 1460)
        XCTAssertEqual(secondPointResult.y, 900)
    }
    
    func testStartGettingLocationStartsPositioningByGPSIfGPSIsAvailable() {
        let expectation = expectation(description: "Test")
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        sut = MockMapManagerSecond()
        sut.positioningManager = MockPositioningManager()
        var p: CGPoint = CGPoint(x: 0, y: 0)
        
        sut.startGettingLocation(mapWidth: 0, mapHeight: 0) { point in
            p = point
        }

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            if locationServicesEnabled && sut.locationManagerAuthorizedWhenInUse() {
                
                XCTAssertEqual(p.x, 0)
                XCTAssertEqual(p.y, 0)
            } else {
                let pm = sut.positioningManager as! MockPositioningManager
                XCTAssertTrue(pm.isInside)
            }
        } else {
            XCTFail()
        }
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
            completionHandler(CGPoint(x: 12, y: 12))
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
    
//    class MockLocationManagerDelegate: LocationManagerDelegate {
//        var isInside = false
//        
//        override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            isInside = true
//        }
//    }
}
