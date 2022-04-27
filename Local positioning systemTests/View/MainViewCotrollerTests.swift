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
}
