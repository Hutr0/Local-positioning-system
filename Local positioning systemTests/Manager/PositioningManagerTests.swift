//
//  PositioningManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreMotion

class PositioningManagerTests: XCTestCase {

    var sut: PositioningManager!
    
    override func setUpWithError() throws {
        sut = PositioningManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMotionManagerIsSet() {
        XCTAssertNotNil(sut.motionManager)
    }
    
    func testDeviceMotionUpdateIntervalIsEqualZeroPointFive() {
        sut.startDeviceMotionUpdateWith(completionHandler: {_ in })
        
        let interval = sut.motionManager.deviceMotionUpdateInterval
        
        XCTAssertEqual(interval, 0.5)
    }
    
    func testDeviceMotionDataIsReturned() {
        let expectation = expectation(description: "Test after five seconds")
        var data: CMDeviceMotion?
        
        sut.startDeviceMotionUpdateWith() { motion in
            data = motion
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(data)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
