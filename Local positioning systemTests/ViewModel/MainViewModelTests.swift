//
//  MainViewModelTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    
    var scrollView: UIScrollView!

    override func setUpWithError() throws {
        sut = MainViewModel(map: UIImageView())
        scrollView = UIScrollView()
    }

    override func tearDownWithError() throws {
        sut = nil
        scrollView = nil
    }

    func testPositioningManagerIsSet() {
        XCTAssertNotNil(sut.positioningManager)
    }
    
    func testCalculateEnterPointCalculatesCorrectlyPoint() {
        let secondScrollView = UIScrollView()
        
        scrollView.contentSize.width = 102
        scrollView.contentSize.height = 7
        scrollView.frame.size.width = 3
        scrollView.frame.size.height = 22
        
        secondScrollView.contentSize.width = 102
        secondScrollView.contentSize.height = 7
        secondScrollView.frame.size.width = 3
        secondScrollView.frame.size.height = 22
        
        let result = sut.calculateEnterPoint(for: scrollView)
        
        let centerOffsetX = (secondScrollView.contentSize.width - secondScrollView.frame.size.width) / 2
        let centerOffsetY = secondScrollView.contentSize.height - secondScrollView.frame.size.height + 100
        let secondResult = CGPoint(x: centerOffsetX, y: centerOffsetY)
        
        XCTAssertEqual(result, secondResult)
    }
    
    func testScrollViewDelegateNotNil() {
        XCTAssertNotNil(sut.scrollViewDelegate)
    }
    
    func testConfigureSetsDelegateScrollViewDelegateForScrollView() {
        sut.configure(scrollView: scrollView)
        
        XCTAssertTrue(scrollView.delegate is ScrollViewDelegate)
    }
    
    func testConfigureSetsZoomScaleForScrollView() {
        sut.configure(scrollView: scrollView)
        
        XCTAssertEqual(scrollView.minimumZoomScale, 0.2)
        XCTAssertEqual(scrollView.maximumZoomScale, 5.0)
    }
    
    func testConfigureSetsContentOffset() {
        sut.configure(scrollView: scrollView)
        
        XCTAssertNotEqual(scrollView.contentOffset, CGPoint(x: 0.0, y: 0.0))
    }
    
//    func testStartPositioningUserCompletionReturnsNotNill() {
//        var result: [Double]?
//
//        sut.startPositioningUser { array in
//            result = array
//        }
//        
//        XCTAssertNotNil(result)
//    }
//
//    func testStartPositioningUserCompletionReturnsAtLeastTwoValuesInArray() {
//        var result: [Double]?
//
//        sut.startPositioningUser { array in
//            result = array
//        }
//
//        XCTAssertGreaterThan(result!.count, 1)
//    }
}
