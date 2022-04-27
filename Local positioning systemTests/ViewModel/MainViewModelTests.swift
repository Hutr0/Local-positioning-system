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

    override func setUpWithError() throws {
        sut = MainViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testPositioningManagerIsSet() {
        XCTAssertNotNil(sut.positioningManager)
    }
    
    func testCalculateEnterPointCalculatesCorrectlyPoint() {
        let scrollView = UIScrollView()
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
