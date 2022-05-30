//
//  MapManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

class GettingInsideManagerTests: XCTestCase {
    
    var sut: GettingInsideManager!

    override func setUpWithError() throws {
        sut = GettingInsideManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testBuildingCoordinateNotNil() {
        XCTAssertNotNil(sut.buildingCoordinates)
    }
    
    func testLocationServicesManagerNotNil() {
        XCTAssertNotNil(sut.locationServicesManager)
    }
    
    func testStartDetectionGettingInsideStartsUpdatingLocation() {
        let expectation = expectation(description: "Test after zero point one")
        var isInside = false
        var loc: Double = 0
        let delegate = LocationManagerDelegate()
        sut.locationServicesManager.locationManager.delegate = delegate
        
        sut.startDetectionGettingInside(completionHandler: { location in
            loc = location.longitude
            isInside = true
        })
        delegate.locationManager(sut.locationServicesManager.locationManager, didUpdateLocations: [CLLocation(latitude: 55.67239263212078, longitude: 37.478994655052944)])
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(isInside)
            XCTAssertNotEqual(loc, 0)
        } else {
            XCTFail("Delay interruped")
        }
    }
    
    func testCheckGettingInsideBuildingWorksCorrectlyFirstTest() {
        let location = CLLocationCoordinate2D(latitude: 55.67239263212078, longitude: 37.478994655052944)
        
        let result = sut.checkGettingInside(in: sut.buildingCoordinates, userLocation: location)
        
        XCTAssertTrue(result)
    }
    
    func testCheckGettingInsideBuildingWorksCorrectlySecondTest() {
        let location = CLLocationCoordinate2D(latitude: 55.671592512248566, longitude: 37.47835052742039)
        
        let result = sut.checkGettingInside(in: sut.buildingCoordinates, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
    func testCheckGettingInsideBuildingWorksCorrectlyThirdTest() {
        let location = CLLocationCoordinate2D(latitude: 55.67239761556922, longitude: 37.478390897967074)
        
        let result = sut.checkGettingInside(in: sut.buildingCoordinates, userLocation: location)
        
        XCTAssertFalse(result)
    }
    
//    func testGetCurrentUserLocationReturnsNotDefaultResult() {
//        let expectation = expectation(description: "Test after zero point one second")
//
//        let defaultLocation = CLLocationCoordinate2D()
//        var location = CLLocation()
//        let delegate = LocationManagerDelegate(locationServicesManager: sut.locationServicesManager)
//        sut.locationServicesManager.locationManager.delegate = delegate
//
//        sut.getCurrentUserLocation() { loc in
//            location = loc
//        }
//
//        let result = XCTWaiter.wait(for: [expectation], timeout: 0.2)
//        if result == XCTWaiter.Result.timedOut {
//            XCTAssertNotEqual(location.coordinate.latitude, defaultLocation.latitude)
//            XCTAssertNotEqual(location.coordinate.longitude, defaultLocation.longitude)
//        } else {
//            XCTFail("Delay interruped")
//        }
//    }
    
    func testSetCompletionToLocationManagerDelegateSetsCompletionToDelegate() {
        let delegate = LocationManagerDelegate()
        sut.locationServicesManager.locationManager.delegate = delegate
        
        var isCompleted = false
        let completion: (CLLocation) -> () = { loc in
            isCompleted = true
        }
        
        sut.setCompletionToLocationManagerDelegate(completion: completion)
        delegate.locationManager(CLLocationManager(), didUpdateLocations: [CLLocation()])
        
        XCTAssertTrue(isCompleted)
    }
    
//    func testGetCurrentUserLocationWorksCorrectly() {
//        let expectation = expectation(description: "Test after zero point one second")
//
//        var isCompleted = false
//        let completion: (CLLocation) -> () = { _ in
//            isCompleted = true
//        }
//        let delegate = LocationManagerDelegate(locationServicesManager: sut.locationServicesManager)
//        sut.locationServicesManager.locationManager.delegate = delegate
//
//        sut.getCurrentUserLocation(completion: completion)
//
//        let result = XCTWaiter.wait(for: [expectation], timeout: 0.2)
//        if result == XCTWaiter.Result.timedOut {
//            XCTAssertTrue(isCompleted)
//        } else {
//            XCTFail("Delay interruped")
//        }
//    }
}
