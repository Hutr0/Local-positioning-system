//
//  ReducingInaccuracyTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class ReducingInaccuracyManagerTests: XCTestCase {
    
    var sut: ReducingInaccuracyManager!

    override func setUpWithError() throws {
        sut = ReducingInaccuracyManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testReduceInaccurancyOnlyWorksAnEvenCountOfElementsOfInputArray() {
        let data = MotionData(rotationRate: RotationRate(x: 1, y: 1, z: 1),
                              attitude: Attitude(roll: 1, pitch: 1, yaw: 1),
                              userAcceleration: UserAcceleration(x: 1, y: 1, z: 1),
                              gravity: Gravity(x: 1, y: 1, z: 1))
        
        let _ = sut.reduceInaccurancy(data: [data, data, data])
        XCTAssertTrue(sut.motionsData.count % 2 == 0)
    }
    
    func testReduceInaccurancyGiveSpecificCountOfElementsToMotionsDataArray() {
        let data = MotionData(rotationRate: RotationRate(x: 1, y: 1, z: 1),
                              attitude: Attitude(roll: 1, pitch: 1, yaw: 1),
                              userAcceleration: UserAcceleration(x: 1, y: 1, z: 1),
                              gravity: Gravity(x: 1, y: 1, z: 1))
        
       let _ =  sut.reduceInaccurancy(data: [data, data, data])
        XCTAssertEqual(sut.motionsData.count, 2)
    }
    
    func testReduceInaccurancyOfElementsCorrectlyWorkedWithGenericRotationRate() {
        let rrFirst = RotationRate(x: 1, y: 1, z: 1)
        let rrSecond = RotationRate(x: 2, y: 2, z: 2)
        let rrThird = RotationRate(x: 3, y: 3, z: 3)
        let rrFourth = RotationRate(x: 4, y: 4, z: 4)
        
        let result = sut.reduceInaccurancyOfElements(array: [rrFirst, rrSecond, rrThird, rrFourth])
        
        XCTAssertEqual(result.x, 2.5)
        XCTAssertEqual(result.y, 2.5)
        XCTAssertEqual(result.z, 2.5)
    }
    
    func testReduceInaccurancyOfElementsCorrectlyWorkedWithGenericAttitude() {
        let aFirst = Attitude(roll: 1, pitch: 1, yaw: 1)
        let aSecond = Attitude(roll: 2, pitch: 2, yaw: 2)
        let aThird = Attitude(roll: 3, pitch: 3, yaw: 3)
        let aFourth = Attitude(roll: 4, pitch: 4, yaw: 4)
        
        let result = sut.reduceInaccurancyOfElements(array: [aFirst, aSecond, aThird, aFourth])
        
        XCTAssertEqual(result.roll, 2.5)
        XCTAssertEqual(result.pitch, 2.5)
        XCTAssertEqual(result.yaw, 2.5)
    }
    
    func testReduceInaccurancyOfElementsCorrectlyWorkedWithGenericUserAcceleration() {
        let aFirst = UserAcceleration(x: 1, y: 1, z: 1)
        let aSecond = UserAcceleration(x: 2, y: 2, z: 2)
        let aThird = UserAcceleration(x: 3, y: 3, z: 3)
        let aFourth = UserAcceleration(x: 4, y: 4, z: 4)
        
        let result = sut.reduceInaccurancyOfElements(array: [aFirst, aSecond, aThird, aFourth])
        
        XCTAssertEqual(result.x, 2.5)
        XCTAssertEqual(result.y, 2.5)
        XCTAssertEqual(result.z, 2.5)
    }
    
    func testReduceInaccurancyOfElementsCorrectlyWorkedWithGenericGravity() {
        let aFirst = Gravity(x: 1, y: 1, z: 1)
        let aSecond = Gravity(x: 2, y: 2, z: 2)
        let aThird = Gravity(x: 3, y: 3, z: 3)
        let aFourth = Gravity(x: 4, y: 4, z: 4)
        
        let result = sut.reduceInaccurancyOfElements(array: [aFirst, aSecond, aThird, aFourth])
        
        XCTAssertEqual(result.x, 2.5)
        XCTAssertEqual(result.y, 2.5)
        XCTAssertEqual(result.z, 2.5)
    }
    
    func testReduceInaccurancyWorkedCorrectly() {
        var motionArray: [MotionData] = []
        
        for i in 0...3 {
            let y = Double(i + 1)
            
            let rr = RotationRate(first: y, second: y, fird: y)
            let a = Attitude(first: y, second: y, fird: y)
            let ua = UserAcceleration(first: y, second: y, fird: y)
            let g = Gravity(first: y, second: y, fird: y)
            
            motionArray.append(MotionData(rotationRate: rr, attitude: a, userAcceleration: ua, gravity: g))
        }
        
        let result = sut.reduceInaccurancy(data: motionArray)
        
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
