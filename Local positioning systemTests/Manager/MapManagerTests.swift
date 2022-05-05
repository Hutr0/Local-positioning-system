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
        let location = CLLocation(latitude: 55.67239263212078, longitude: 37.47897356390552)
        
        let result = sut.checkGettingInside(in: sut.buildingArea, userLocation: location)
        
        XCTAssertTrue(result)
    }
    
    func testCheckGettingInsideAreaWorksCorrectlySecondTest() {
        let location = CLLocation(latitude: 55.671592512248566, longitude: 37.47835052742039)
        
        let result = sut.checkGettingInside(in: sut.buildingArea, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testCheckGettingInsideAreaWorksCorrectlyThirdTest() {
        let location = CLLocation(latitude: 55.67239761556922, longitude: 37.478390897967074)
        
        let result = sut.checkGettingInside(in: sut.buildingArea, userLocation: location)
        
        XCTAssertTrue(result)
    }
    
    func testCheckGettingInsideBuildingWorksCorrectlyFirstTest() {
        let location = CLLocation(latitude: 55.67239263212078, longitude: 37.478994655052944)
        
        let result = sut.checkGettingInside(in: sut.buildingCoordinate, userLocation: location)
        
        XCTAssertTrue(result)
    }
    
    func testCheckGettingInsideBuildingWorksCorrectlySecondTest() {
        let location = CLLocation(latitude: 55.671592512248566, longitude: 37.47835052742039)
        
        let result = sut.checkGettingInside(in: sut.buildingCoordinate, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testCheckGettingInsideBuildingWorksCorrectlyThirdTest() {
        let location = CLLocation(latitude: 55.67239761556922, longitude: 37.478390897967074)
        
        let result = sut.checkGettingInside(in: sut.buildingCoordinate, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testGettingInsideAreaFourth() {
        let location = CLLocation(latitude: 55.67194178348394, longitude: 37.47846747199399)
        
        let result = sut.checkGettingInside(in: sut.buildingArea, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testGettingInsideAreaFifth() {
        let location = CLLocation(latitude: 55.67180389258219, longitude: 37.47807658227939)
        
        let result = sut.checkGettingInside(in: sut.buildingArea, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testGettingInsideArea6() {
        let location = CLLocation(latitude: 55.672612841598145, longitude: 37.47935890790105)
        
        let result = sut.checkGettingInside(in: sut.buildingArea, userLocation: location)
        
        XCTAssertTrue(result)
    }
    
    func testGettingInsideArea7() {
        let location = CLLocation(latitude: 55.672896696472215, longitude: 37.479700442533364)
        
        let result = sut.checkGettingInside(in: sut.buildingArea, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testGetCurrentUserLocationReturnsNotDefaultResult() {
        let expectation = expectation(description: "Test after zero point one second")
        
        let defaultLocation = CLLocationCoordinate2D()
        var location = CLLocation()
        let delegate = LocationManagerDelegate(locationServicesManager: sut.locationServicesManager)
        sut.locationServicesManager.locationManager.delegate = delegate
        
        sut.getCurrentUserLocation() { loc in
            location = loc
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.2)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotEqual(location.coordinate.latitude, defaultLocation.latitude)
            XCTAssertNotEqual(location.coordinate.longitude, defaultLocation.longitude)
        } else {
            XCTFail("Delay interruped")
        }
    }
    
    func testSetCompletionToLocationManagerDelegateSetsCompletionToDelegate() {
        let delegate = LocationManagerDelegate(locationServicesManager: sut.locationServicesManager)
        sut.locationServicesManager.locationManager.delegate = delegate
        
        var isCompleted = false
        let completion: (CLLocation) -> () = { loc in
            isCompleted = true
        }
        
        sut.setCompletionToLocationManagerDelegate(completion: completion)
        delegate.locationManager(CLLocationManager(), didUpdateLocations: [CLLocation()])
        
        XCTAssertTrue(isCompleted)
    }
    
    func testGetCurrentUserLocationWorksCorrectly() {
        let expectation = expectation(description: "Test after zero point one second")
        
        var isCompleted = false
        let completion: (CLLocation) -> () = { _ in
            isCompleted = true
        }
        let delegate = LocationManagerDelegate(locationServicesManager: sut.locationServicesManager)
        sut.locationServicesManager.locationManager.delegate = delegate
        
        sut.getCurrentUserLocation(completion: completion)
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.2)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(isCompleted)
        } else {
            XCTFail("Delay interruped")
        }
    }
}
