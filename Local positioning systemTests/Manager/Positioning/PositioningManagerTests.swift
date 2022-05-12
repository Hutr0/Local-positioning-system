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
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in })
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInsideReducing)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
//    func testReducingInaccurancyHaveMaximumHundredValues() {
//        var array: [MotionData] = []
//
//        for _ in 0...99 {
//            let motionData = MotionData(rotationRate: RotationRate(x: 1, y: 1, z: 1),
//                                        attitude: Attitude(roll: 1, pitch: 1, yaw: 1),
//                                        userAcceleration: UserAcceleration(x: 1, y: 1, z: 1),
//                                        gravity: Gravity(x: 1, y: 1, z: 1))
//            array.append(motionData)
//        }
//        sut.motionsData = array
//        for _ in 0..<4 {
//            sut.reducingInaccurancy(data: array)
//        }
//        XCTAssertEqual(sut.motionsData.count, 100)
//    }
    
    func testStartrecordingMotionsAfterTenIterationsCallReducingInaccurancyMethod() {
        let expectation = expectation(description: "Test after zero point one hudred five seconds")
        sut = MockPositioningManager()
        
        sut.positioningMotionManager.changeDeviceMotionUpdateInterval(to: 0.01)
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in})
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.11)
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
        let expectation = expectation(description: "Test after zero point one hudred five seconds")
        var isInside = false
        
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: { _ in
            isInside = true
        })
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(isInside)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
//    func testMotionsDataNotNilAfterStartRecordingMotions() {
//        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in})
//
//        XCTAssertNotNil(sut.motionsData)
//    }
    
    func testStartRecordingMotionsCallsUpdateCoordinates() {
        sut = MockPositioningManager()
        
        sut.updateCoordinates(motionData: motionData, closure: {_ in})
        
        XCTAssertTrue((sut as! MockPositioningManager).isInsideUpdate)
    }
    
    func testUpdateCoordinatesSetsNewCoordinate() {
        let newCoordinates = CLLocation(latitude: 1, longitude: 1)
        sut.currentPosition = Position(coordinates: newCoordinates, speedX: 0, speedZ: 0)
        
        sut.updateCoordinates(motionData: motionData, closure: {_ in})
        
        XCTAssertNotEqual(sut.currentPosition.coordinates, newCoordinates)
    }
    
    func testCurrentCoordinatesNotNilAfterStartRecordingMotions() {
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in})
        
        XCTAssertNotNil(sut.currentPosition)
    }
    
    func testUpdateCoordinatesCallsClosure() {
        sut.currentPosition = Position(coordinates: CLLocation(latitude: 0, longitude: 0), speedX: 0, speedZ: 0)
        var isInside = false
        let closure: ((CLLocation) -> ()) = { _ in
            isInside = true
        }
        
        sut.updateCoordinates(motionData: motionData, closure: closure)
        
        XCTAssertTrue(isInside)
    }
    
    func testStartRecordingMotionsSetsUpdateintervalToZeroPointZeroOne() {
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in})
        
        let interval = sut.positioningMotionManager.motionManager.deviceMotionUpdateInterval
        
        XCTAssertEqual(interval, 0.01)
    }
    
    func testStartRecordingMotionsCallsReducingInaccurancyAfterZeroPointOneSeconds() {
        let expectation = expectation(description: "Test after zero point twelve seconds")
        sut = MockPositioningManager()
        
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in})
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.12)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInsideReducing)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartRecordingMotionsRemovesCallsUpdateCoordinatesAfterOneSecond() {
        let expectation = expectation(description: "Test after one point twelve seconds")
        sut = MockPositioningManager()
        
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in})
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 1.12)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue((sut as! MockPositioningManager).isInsideUpdate)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testStartRecordingMotionsSetUpdateIntervalEqualsTimeInterval() {
        let interval = sut.timeInterval
        
        sut.startRecordingMotions(coordinatesOfStart: CLLocation(), closure: {_ in})

        XCTAssertEqual(interval, sut.positioningMotionManager.motionManager.deviceMotionUpdateInterval)
    }
    
    func testUpdateCoordinatesSetsNewCoordinates() {
        let startCurrentCoordinates = CLLocation(latitude: 10, longitude: 10)
        sut.currentPosition = Position(coordinates: startCurrentCoordinates, speedX: 0, speedZ: 0)
        
        sut.updateCoordinates(motionData: motionData, closure: {_ in})
        
        XCTAssertNotEqual(startCurrentCoordinates.coordinate.latitude, sut.currentPosition.coordinates.coordinate.latitude)
        XCTAssertNotEqual(startCurrentCoordinates.coordinate.longitude, sut.currentPosition.coordinates.coordinate.longitude)
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
        
        override func updateCoordinates(motionData: MotionData, closure: @escaping (CLLocation) -> ()) {
            isInsideUpdate = true
        }
    }
}
