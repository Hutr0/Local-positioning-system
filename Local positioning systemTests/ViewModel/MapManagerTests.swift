//
//  MapViewModelTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
import MapKit
@testable import Local_positioning_system

class MapManagerTests: XCTestCase {

    var sut: MapManager!
    
    override func setUpWithError() throws {
        sut = MapManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testLocationManagerNotNil() {
        XCTAssertNotNil(sut.locationManager)
    }
    
    func testCheckLocationServicesStartsCheckLocationAutorizationIfLocationServicesEnabled() {
        sut = MockMapManager()
        
        sut.checkLocationServices(mapView: MKMapView()) {}
        
        if CLLocationManager.locationServicesEnabled() {
            XCTAssertTrue((sut as! MockMapManager).isInside)
        }
    }
    
    func testCheckLocationAutorizationStartsShowUserLocationIfAuthorizationStatusIsAuthorizedWhenInUse() {
        sut = MockMapManager()
        
        sut.checkLocationAutorization(mapView: MKMapView())
        
        if sut.locationManager.authorizationStatus == .authorizedWhenInUse {
            XCTAssertTrue((sut as! MockMapManager).isInside)
        }
    }
}

extension MapManagerTests {
    class MockMapManager: MapManager {
        var isInside = false
        
        override func checkLocationAutorization(mapView: MKMapView) {
            isInside = true
        }
        
        override func showUserLocation(mapView: MKMapView) {
            isInside = true
        }
    }
}
