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
