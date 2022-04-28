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
        sut = LocationManagerDelegate(locationServicesManager: LocationServicesManager())
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMapManagerNotNilAfterInit() {
        XCTAssertNotNil(sut.locationServicesManager)
    }
    
    func testCompletionHandlerNotNilAfterSet() {
        sut.completionHandler = { _ in }
        XCTAssertNotNil(sut.completionHandler)
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
}
