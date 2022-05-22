//
//  LocationManagerDelegateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

class LocationManagerDelegateTests: XCTestCase {

    var sut: LocationManagerDelegate!

    override func setUpWithError() throws {
        sut = LocationManagerDelegate()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testLocationServicesManagerNotNilAfterInit() {
        XCTAssertNotNil(sut.locationServicesManager)
    }
    
    func testCompletionHandlerNotNilAfterSet() {
        sut.completionHandler = { _ in }
        XCTAssertNotNil(sut.completionHandler)
    }
    
    func testCompletionHeadingNotNilAfterSet() {
        sut.completionHandler = { _ in }
        XCTAssertNotNil(sut.completionHeading)
    }
    
    func testUpdateLocationCallsCompletionHandler() {
        var isCalled = false
        sut.completionHandler = { _ in
            isCalled = true
        }
        
        sut.locationManager(CLLocationManager(), didUpdateLocations: [CLLocation()])
        
        XCTAssertTrue(isCalled)
    }
    
    func testUpdateLocationReturnsLocationInCompeltion() {
        let startLocation = CLLocation(latitude: 1, longitude: 1)
        var location: CLLocation = CLLocation()
        sut.completionHandler = { loc in
            location = loc
        }
        
        sut.locationManager(CLLocationManager(), didUpdateLocations: [startLocation])
        
        XCTAssertEqual(location, startLocation)
    }
    
    func testUpdateHeadingCallsCompletionHeading() {
        var isCalled = false
        sut.completionHeading = { _ in
            isCalled = true
        }
        
        sut.locationManager(sut.locationServicesManager.locationManager, didUpdateHeading: CLHeading())
        
        XCTAssertTrue(isCalled)
    }
}
