//
//  MainViewCotrollerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class MainViewCotrollerTests: XCTestCase {
    
    var sut: MainViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self))
        sut = vc as? MainViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testViewModelIsSet() {
        XCTAssertNotNil(sut.viewModel)
    }
    
    func testUserIsExists() {
        XCTAssertNotNil(sut.user)
    }
    
    func testScrollViewIsExists() {
        XCTAssertNotNil(sut.scrollView)
    }
    
    func testMapIsExists() {
        XCTAssertNotNil(sut.map)
    }
    
    func testScrollViewHasDelegate() {
        XCTAssertNotNil(sut.scrollView.delegate)
    }
    
    func testScrollViewDelegateIsMVC() {
        XCTAssertTrue(sut.scrollView.delegate is MainViewController)
    }
    
    func testScrollViewIsConfigured() {
        XCTAssertEqual(sut.scrollView.minimumZoomScale, 1)
        XCTAssertEqual(sut.scrollView.maximumZoomScale, 5)
    }
    
    func testMapViewOnStartIsHidden() {
        XCTAssertTrue(sut.mapView.isHidden)
    }
    
    func testMapButtonPressedToogleValues() {
        sut.mapButtonPressed(sut.mapButton)
        XCTAssertFalse(sut.mapView.isHidden)
        XCTAssertTrue(sut.map.isHidden)
        XCTAssertTrue(sut.user.isHidden)
    }
    
    func testMapManagerNotNil() {
        XCTAssertNotNil(sut.mapManager)
    }
    
    func testMapViewDelegateIsMapManager() {
        XCTAssertTrue(sut.mapView.delegate is MapManager)
    }
}
