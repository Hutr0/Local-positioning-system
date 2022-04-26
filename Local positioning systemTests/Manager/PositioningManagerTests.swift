//
//  PositioningManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class PositioningManagerTests: XCTestCase {

    var sut: PositioningManager!
    
    override func setUpWithError() throws {
        sut = PositioningManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testPositioningMotionManagerIsSet() {
        XCTAssertNotNil(sut.positioningMotionManager)
    }
    
    func testStartRecordingMotionsIsRecoedAtLeastOneValue() {
        let expectation = expectation(description: "Test after one seconds")
        
        sut.startRecordingMotions()
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertGreaterThan(sut.motionData.count, 0)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
