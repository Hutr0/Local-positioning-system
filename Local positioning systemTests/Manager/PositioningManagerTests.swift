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
    
    func testReducingInaccurancyManagerIsSet() {
        XCTAssertNotNil(sut.reducingInaccurancyManager)
    }
    
    func testMovementAnalysisIsSet() {
        XCTAssertNotNil(sut.movementAnalysisManager)
    }
    
    func testReducingInaccurancyStarting() {
        let expectation = expectation(description: "Test after zero point eleven seconds")
        sut = MockPositioningManager()
        
        sut.positioningMotionManager.changeDeviceMotionUpdateInterval(to: 0.01)
        sut.startRecordingMotions()
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.11)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInside)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testReducingInaccurancyHaveMaximumHundredValues() {
        var array: [MotionData] = []
        
        for _ in 0...99 {
            let motionData = MotionData(rotationRate: RotationRate(x: 1, y: 1, z: 1),
                                        attitude: Attitude(roll: 1, pitch: 1, yaw: 1),
                                        userAcceleration: UserAcceleration(x: 1, y: 1, z: 1),
                                        gravity: Gravity(x: 1, y: 1, z: 1))
            array.append(motionData)
        }
        sut.motionsData = array
        for _ in 0..<4 {
            sut.reducingInaccurancy(data: array)
        }
        XCTAssertEqual(sut.motionsData.count, 100)
    }
    
    func testStartrecordingMotionsAfterTenIterationsCallReducingInaccurancyMethod() {
        let expectation = expectation(description: "Test after zero point one hudred five seconds")
        sut = MockPositioningManager()
        
        sut.positioningMotionManager.changeDeviceMotionUpdateInterval(to: 0.01)
        sut.startRecordingMotions()
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.105)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInside)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testReducingInaccurancyCorrectlyAddAResultIntoMotionsData() {
        var motionArray: [MotionData] = []
        for _ in 0...1 {
            for i in 0...10 {
                let y = Double(i + 1)
                
                let rr = RotationRate(first: y, second: y, fird: y)
                let a = Attitude(first: y, second: y, fird: y)
                let ua = UserAcceleration(first: y, second: y, fird: y)
                let g = Gravity(first: y, second: y, fird: y)
                
                motionArray.append(MotionData(rotationRate: rr, attitude: a, userAcceleration: ua, gravity: g))
            }
            
            sut.reducingInaccurancy(data: motionArray)
        }
        
        XCTAssertEqual(sut.motionsData.count, 2)
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
        
        sut.reducingInaccurancy(data: motionArray)
        
        let result = sut.motionsData[0]
        
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
}

extension PositioningManagerTests {
    class MockPositioningManager: PositioningManager {
        var isInside = false
        
        override func reducingInaccurancy(data: [MotionData]) {
            isInside = true
        }
    }
}
