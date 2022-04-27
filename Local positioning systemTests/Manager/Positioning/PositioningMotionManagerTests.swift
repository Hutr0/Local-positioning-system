//
//  PositioningManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreMotion

class PositioningMotionManagerTests: XCTestCase {

    var sut: PositioningMotionManager!
    
    override func setUpWithError() throws {
        sut = PositioningMotionManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMotionManagerIsSet() {
        XCTAssertNotNil(sut.motionManager)
    }
    
    func testDeviceMotionUpdateIntervalOnInitIsEqualZeroPointFive() {
        XCTAssertEqual(sut.motionManager.deviceMotionUpdateInterval, 0.5)
    }
    
    func testStartDeviceMotionUpdateIsStartUpdateing() {
        let expectation = expectation(description: "Test after one seconds")
        
        XCTAssertEqual(sut.motionManager.isDeviceMotionActive, false)
        
        sut.startDeviceMotionUpdate(completionHandler: { _,_,_,_ in })
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(sut.motionManager.isDeviceMotionActive, true)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartDeviceMotionUpdateReturnsAllNotNill() {
        let expectation = expectation(description: "Test after one seconds")
        var XCTRotationRate: RotationRate?
        var XCTAttitude: Attitude?
        var XCTUserAcceleration: UserAcceleration?
        var XCTGravity: Gravity?
        
        sut.startDeviceMotionUpdate { rotationRate, attitude, userAcceleration, gravity in
            XCTRotationRate = rotationRate
            XCTAttitude = attitude
            XCTUserAcceleration = userAcceleration
            XCTGravity = gravity
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(XCTRotationRate)
            XCTAssertNotNil(XCTAttitude)
            XCTAssertNotNil(XCTUserAcceleration)
            XCTAssertNotNil(XCTGravity)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartDeviceMotionUpdateReturnsAllRotationRateValues() {
        let expectation = expectation(description: "Test after one seconds")
        var XCTRotationRate: RotationRate?
        
        sut.startDeviceMotionUpdate { rotationRate, _, _, _ in
            XCTRotationRate = rotationRate
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(XCTRotationRate?.x)
            XCTAssertNotNil(XCTRotationRate?.y)
            XCTAssertNotNil(XCTRotationRate?.z)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartDeviceMotionUpdateReturnsAllUserAccelerationValues() {
        let expectation = expectation(description: "Test after one seconds")
        var XCTUserAcceleration: UserAcceleration?
        
        sut.startDeviceMotionUpdate { _, _, userAcceleration, _ in
            XCTUserAcceleration = userAcceleration
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(XCTUserAcceleration?.x)
            XCTAssertNotNil(XCTUserAcceleration?.y)
            XCTAssertNotNil(XCTUserAcceleration?.z)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartDeviceMotionUpdateReturnsAllAttitudeValues() {
        let expectation = expectation(description: "Test after one seconds")
        var XCTAttitude: Attitude?
        
        sut.startDeviceMotionUpdate { _, attitude, _, _ in
            XCTAttitude = attitude
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(XCTAttitude?.roll)
            XCTAssertNotNil(XCTAttitude?.pitch)
            XCTAssertNotNil(XCTAttitude?.yaw)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartDeviceMotionUpdateReturnsAllGravityValues() {
        let expectation = expectation(description: "Test after one seconds")
        var XCTGravity: Gravity?
        
        sut.startDeviceMotionUpdate { _, _, _, gravity in
            XCTGravity = gravity
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(XCTGravity?.x)
            XCTAssertNotNil(XCTGravity?.y)
            XCTAssertNotNil(XCTGravity?.z)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStopDeviceMotionUpdateIsStoppingUpdate() {
        let expectation = expectation(description: "Test after zero point one")
        
        sut.startDeviceMotionUpdate { _, _, _, _ in }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(sut.motionManager.isDeviceMotionActive)
        } else {
            XCTFail("Delay interrupted")
        }
        
        sut.stopDeviceMotionUpdate()
        XCTAssertTrue(!sut.motionManager.isDeviceMotionActive)
    }
    
    func testChangeDeviceMotionUpdateIntervalIsUpdatingInterval() {
        XCTAssertEqual(sut.motionManager.deviceMotionUpdateInterval, 0.5)
        
        sut.changeDeviceMotionUpdateInterval(to: 0.2)
        
        XCTAssertEqual(sut.motionManager.deviceMotionUpdateInterval, 0.2)
    }
    
    func testIfDeviceMotionNotAvailableThenMethodIsStoped() {
        let expectation = expectation(description: "Test after zero point one seconds")
        sut.startDeviceMotionUpdate { _, _, _, _ in }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            if sut.motionManager.isDeviceMotionAvailable == false {
                XCTAssertFalse(sut.motionManager.isDeviceMotionActive)
            } else {
                XCTAssertTrue(sut.motionManager.isDeviceMotionActive)
            }
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
//    func testDeviceMotionUpdateIntervalIsEqualZeroPointFive() {
//        sut.startDeviceMotionUpdateWith(completionHandler: {_ in })
//
//        let interval = sut.motionManager.deviceMotionUpdateInterval
//        
//        XCTAssertEqual(interval, 0.5)
//    }
//
//    func testDeviceMotionDataIsReturned() {
//        let expectation = expectation(description: "Test after five seconds")
//        var data: CMDeviceMotion?
//
//        sut.startDeviceMotionUpdateWith() { motion in
//            data = motion
//        }
//
//        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
//        if result == XCTWaiter.Result.timedOut {
//            XCTAssertNotNil(data)
//        } else {
//            XCTFail("Delay interrupted")
//        }
//    }
}
