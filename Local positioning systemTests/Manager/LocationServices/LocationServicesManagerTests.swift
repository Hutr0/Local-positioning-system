//
//  BuildingManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

class LocationServicesManagerTests: XCTestCase {

    var sut: LocationServicesManager!
    
    override func setUpWithError() throws {
        sut = LocationServicesManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCheckLocationServicesSetsDesiredAccuracyOnCLLocationAccuracyBestIfLocationServicesEnabled() {
        sut.checkLocationServices()
        
        if CLLocationManager.locationServicesEnabled() {
            XCTAssertTrue(sut.locationManager.desiredAccuracy == kCLLocationAccuracyBest)
        }
    }
    
    func testCheckLocationServicesStartCheckLocationAutorizationIfLocationServicesEnabled() {
        sut.checkLocationServices()
        
        if CLLocationManager.locationServicesEnabled() {
            XCTAssertNotNil(sut.locationManager.delegate)
        }
    }
    
    func testGetCurrentMagneticHeadingWorksCorrectly() {
        let expectation = expectation(description: "Test after zero point one seconds")
        var value: CLLocationDirection?
        
        sut.getCurrentMagneticHeading { dir in
            value = dir
        }
        
        if CLLocationManager.headingAvailable() {
            let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
            if result == XCTWaiter.Result.timedOut {
                XCTAssertNotNil(value)
            } else {
                XCTFail("Delay interrupted")
            }
        } else {
            XCTAssertNil(value)
        }
    }
}
