//
//  PositioningManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
import CoreLocation
@testable import Local_positioning_system

class PositioningManagerTests: XCTestCase {

    var sut: PositioningManager!
    var motionData: MotionData!
    
    override func setUpWithError() throws {
        sut = PositioningManager()
        motionData = MotionData(rotationRate: RotationRate(first: 1, second: 1, fird: 1), attitude: Attitude(first: 1, second: 1, fird: 1), userAcceleration: UserAcceleration(first: 1, second: 1, fird: 1), gravity: Gravity(first: 1, second: 1, fird: 1))
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMotionManagerIsSet() {
        XCTAssertNotNil(sut.motionManager)
    }
    
    func testReducingInaccurancyManagerIsSet() {
        XCTAssertNotNil(sut.reducingInaccurancyManager)
    }
    
    func testMovementAnalysisIsSet() {
        XCTAssertNotNil(sut.movementAnalysisManager)
    }
    
    func testReducingInaccurancyStarting() {
        let expectation = expectation(description: "Test after zero point eleven seconds")
        sut = MockPositioningManager()

        sut.motionManager.changeDeviceMotionUpdateInterval(to: 0.01)
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: {_ in })

        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInsideReducing)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartRecordingMotionsAfterFiveIterationsCallReducingInaccurancyMethod() {
        let expectation = expectation(description: "Test after zero point five seconds")
        sut = MockPositioningManager()

        sut.motionManager.changeDeviceMotionUpdateInterval(to: 0.01)
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: {_ in})

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.4)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInsideReducing)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testReducingInaccurancyCorrectlyAddAResultIntoMotionsData() {
        var motionArray: [MotionData] = []
        var result: [MotionData] = []
        for _ in 0...1 {
            for i in 0...10 {
                let y = Double(i + 1)

                let rr = RotationRate(first: y, second: y, fird: y)
                let a = Attitude(first: y, second: y, fird: y)
                let ua = UserAcceleration(first: y, second: y, fird: y)
                let g = Gravity(first: y, second: y, fird: y)

                motionArray.append(MotionData(rotationRate: rr, attitude: a, userAcceleration: ua, gravity: g))
            }

            result.append(sut.reducingInaccurancy(data: motionArray))
        }

        XCTAssertEqual(result.count, 2)
    }
    
    func testReducingInaccurancyCorrectlyGiveAResultToMotionsData() {
        var motionArray: [MotionData] = []

        for i in 0...3 {
            let y = Double(i + 1)

            let rr = RotationRate(first: y, second: y, fird: y)
            let a = Attitude(first: y, second: y, fird: y)
            let ua = UserAcceleration(first: y, second: y, fird: y)
            let g = Gravity(first: y, second: y, fird: y)

            motionArray.append(MotionData(rotationRate: rr, attitude: a, userAcceleration: ua, gravity: g))
        }

        let result = sut.reducingInaccurancy(data: motionArray)

        XCTAssertEqual(result.rotationRate.x, 2.5)
        XCTAssertEqual(result.rotationRate.y, 2.5)
        XCTAssertEqual(result.rotationRate.z, 2.5)

        XCTAssertEqual(result.attitude.roll, 2.5)
        XCTAssertEqual(result.attitude.pitch, 2.5)
        XCTAssertEqual(result.attitude.yaw, 2.5)

        XCTAssertEqual(result.userAcceleration.x, 2.5)
        XCTAssertEqual(result.userAcceleration.y, 2.5)
        XCTAssertEqual(result.userAcceleration.z, 2.5)

        XCTAssertEqual(result.gravity.x, 2.5)
        XCTAssertEqual(result.gravity.y, 2.5)
        XCTAssertEqual(result.gravity.z, 2.5)
    }
    
    func testStartRecordingMotionsCallsClosure() {
        let expectation = expectation(description: "Test after zero point six seconds")
        var isInside = false
        
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: { _ in
            isInside = true
        })
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.2)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(isInside)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartRecordingMotionsCallsUpdateCoordinates() {
        let expectation = expectation(description: "Test after zero point one seconds")
        sut = MockPositioningManager()
        
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: {_ in})
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.4)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInsideUpdate)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testUpdateCoordinatesSetsNewCoordinate() {
        let newPosition = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        sut.currentPosition = newPosition
        
        sut.updateCoordinates(heading: 0, motionData: motionData, closure: {_ in})
        
        XCTAssertNotEqual(sut.currentPosition.x, newPosition.x)
        XCTAssertNotEqual(sut.currentPosition.y, newPosition.y)
        XCTAssertNotEqual(sut.currentPosition.z, newPosition.z)
    }
    
    func testCurrentCoordinatesNotNilAfterStartRecordingMotions() {
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: {_ in})
        
        XCTAssertNotNil(sut.currentPosition)
    }
    
    func testUpdateCoordinatesCallsClosure() {
        sut.currentPosition = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        var isInside = false
        let closure: ((CGPoint) -> ()) = { _ in
            isInside = true
        }
        
        sut.updateCoordinates(heading: 0, motionData: motionData, closure: closure)
        
        XCTAssertTrue(isInside)
    }
    
    func testStartRecordingMotionsSetsUpdateIntervalTo60Gz() {
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: {_ in})
        
        let interval = sut.motionManager.motionManager.deviceMotionUpdateInterval
        
        XCTAssertEqual(interval, 1/60)
    }
    
    func testStartRecordingMotionsCallsReducingInaccurancyAfterZeroPointOneSeconds() {
        let expectation = expectation(description: "Test after zero point six seconds")
        sut = MockPositioningManager()
        
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: {_ in})

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.6)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInsideReducing)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartRecordingMotionsSetUpdateIntervalEqualsTimeInterval() {
        let interval = sut.timeInterval
        
        sut.startRecordingMotions(pointOfStart: CGPoint(), closure: {_ in})

        XCTAssertEqual(interval, sut.motionManager.motionManager.deviceMotionUpdateInterval)
    }
}

extension PositioningManagerTests {
    class MockPositioningManager: PositioningManager {
        var isInsideReducing = false
        var isInsideUpdate = false
        
        override func reducingInaccurancy(data: [MotionData]) -> MotionData {
            isInsideReducing = true

            return MotionData(rotationRate: RotationRate(first: 0, second: 0, fird: 0), attitude: Attitude(first: 0, second: 0, fird: 0), userAcceleration: UserAcceleration(first: 0, second: 0, fird: 0), gravity: Gravity(first: 0, second: 0, fird: 0))
        }
        
        override func updateCoordinates(heading: Double, motionData: MotionData, closure: @escaping (CGPoint) -> ()) {
            isInsideUpdate = true
        }
    }
}
