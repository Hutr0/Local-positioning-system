//
//  TimerManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import XCTest
@testable import Local_positioning_system

class TimerManagerTests: XCTestCase {

    var sut: TimerManager!

    override func setUpWithError() throws {
        sut = TimerManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testStartTimerStartsTimer() {
        let expectation = expectation(description: "Test after zero point eleven seconds")
        var isComlete = false
        
        sut.startTimer(timeInterval: 0.1) {
            isComlete = true
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.11)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(isComlete)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testStopTimerStopsTimer() {
        sut.startTimer(timeInterval: 0.5) {}
        sut.stopTimer()
        
        XCTAssertTrue(sut.timer.fireDate < .now)
    }
    
    func testStartTimerMultiplyDontStartsTimer() {
        let expectation = expectation(description: "Test after zero point zero one seconds")
        var counter = 1
        
        sut.startTimer(timeInterval: 0.01) {
            counter += 1
        }
        sut.startTimer(timeInterval: 0.01) {
            counter += 1
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.055)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(counter, 6)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
