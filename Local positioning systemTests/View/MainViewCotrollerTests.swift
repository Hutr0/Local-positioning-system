//
//  MainViewCotrollerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

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
    
    func testUserConstraintToLeadingNotNil() {
        XCTAssertNotNil(sut.userConstraintToLeading)
    }
    
    func testUserConstraintToTopNotNil() {
        XCTAssertNotNil(sut.userConstraintToTop)
    }
    
    func testScrollViewHasDelegate() {
        XCTAssertNotNil(sut.scrollView.delegate)
    }
    
    func testScrollViewIsConfigured() {
        XCTAssertEqual(sut.scrollView.minimumZoomScale, 0.2)
        XCTAssertEqual(sut.scrollView.maximumZoomScale, 5)
    }
    
    func testScrollViewHasScrollViewDelegateDelegate() {
        XCTAssertTrue(sut.scrollView.delegate is ScrollViewDelegate)
    }
    
    func testScrollViewContentOffsetSetsOnEnterPoint() {
        XCTAssertNotEqual(sut.scrollView.contentOffset, CGPoint(x: 0.0, y: 0.0))
    }
    
    func testUserXIsSetAfterViewDidLoad() {
        XCTAssertNotNil(sut.userX)
    }
    
    func testUserYIsSetAfterViewDidLoad() {
        XCTAssertNotNil(sut.userY)
    }
    
    func testUserValuesEqualsUserFrameAfterViewDidLoad() {
        XCTAssertEqual(sut.userX, sut.user.frame.origin.x)
        XCTAssertEqual(sut.userY, sut.user.frame.origin.y)
    }
    
    func testUserConstraintsUpdatesWhenScrollViewZooming() {
        let userX = sut.userX!
        let userY = sut.userY!
        let zoom = 0.5
        
        sut.scrollView.zoomScale = zoom
        
        XCTAssertEqual(userX * zoom, sut.userConstraintToLeading.constant)
        XCTAssertEqual(userY * zoom, sut.userConstraintToTop.constant)
    }
    
    func testUserConstraintsDontUpdateIfUserXIsNil() {
        let zoom = 0.5
        let userX = sut.userX!
        sut.userX = nil
        
        sut.scrollView.zoomScale = zoom
        
        XCTAssertNotEqual(userX * zoom, sut.userConstraintToLeading.constant)
    }
    
    func testUserConstraintsDontUpdateIfUserYIsNil() {
        let zoom = 0.5
        let userY = sut.userY!
        sut.userY = nil
        
        sut.scrollView.zoomScale = zoom
        
        XCTAssertNotEqual(userY * zoom, sut.userConstraintToTop.constant)
    }
    
    func testUserIsHiddenAfterInit() {
        XCTAssertTrue(sut.user.isHidden)
    }
}
