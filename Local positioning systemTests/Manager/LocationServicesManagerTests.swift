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
        sut = LocationServicesManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCheckLocationServicesSetsDesiredAccuracyOnkCLLocationAccuracyBestIfLocationServicesEnabled() {
        sut.checkLocationServices()
        
        if CLLocationManager.locationServicesEnabled() {
            XCTAssertTrue(sut.locationManager.desiredAccuracy == kCLLocationAccuracyBest)
        }
    }
    
    func testCheckLocationServicesStartCheckLocationAutorizationIfLocationServicesEnabled() {
        sut = MockLocationServicesManager()
        sut.checkLocationServices()
        
        if CLLocationManager.locationServicesEnabled() {
            XCTAssertTrue((sut as! MockLocationServicesManager).isInside)
        }
    }
}

extension LocationServicesManagerTests {
    class MockLocationServicesManager: LocationServicesManager {
        var isInside = false
        
        override func checkLocationAutorization() {
            isInside = true
        }
    }
}
