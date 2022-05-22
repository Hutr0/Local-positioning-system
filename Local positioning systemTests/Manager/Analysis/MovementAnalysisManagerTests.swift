//
//  MovementAnalysisTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system
import CoreLocation

class MovementAnalysisManagerTests: XCTestCase {
    
    var sut: MovementAnalysisManager!
    var motionData: MotionData!

    override func setUpWithError() throws {
        sut = MovementAnalysisManager()
        motionData = MotionData(rotationRate: RotationRate(first: 1, second: 1, fird: 1), attitude: Attitude(first: 1, second: 1, fird: 1), userAcceleration: UserAcceleration(first: 1, second: 1, fird: 1), gravity: Gravity(first: 1, second: 1, fird: 1))
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetNewCoordinatesWorksCorrecly() {
        
    }
    
    func testGetNewYawWorksCorrectlyFirst() {
        let heading = 90.0
        let yaw = 0.0
        let angle = heading - BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlySecond() {
        let heading = 180.0
        let yaw = 0.0
        let angle = heading + BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: -angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlyThird() {
        let heading = 270.0
        let yaw = 0.0
        let angle = 360 - heading + BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: -angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlyFourth() {
        let heading = 0.0
        let yaw = 0.0
        let angle = heading - BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlyFifth() {
        let heading = 0.0
        let yaw = -1.5
        let angle = heading - BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlySixth() {
        let heading = 0.0
        let yaw = 1.5
        let angle = heading - BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlySeventh() {
        let heading = 0.0
        let yaw = 3.0
        let angle = heading - BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlyEighth() {
        let heading = 180.0
        let yaw = -1.5
        let angle = heading + BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: -angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlyNineth() {
        let heading = 90.0
        let yaw = 1.5
        let angle = heading - BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testGetNewYawWorksCorrectlyTenth() {
        let heading = 270.0
        let yaw = -1.5
        let angle = 360 - heading + BuildingManager.shared.getAngleOfBuilding()
        let newYaw = PhysMathManager.rotateYaw(withValue: yaw, byAngle: -angle)
        
        let result = sut.getNewYaw(yaw, fromHeading: heading)
        
        XCTAssertEqual(result, newYaw)
    }
    
    func testConversionAxesByYawCalculateTopRightSectionAcceleration() {
        let yaw = -0.75
        let acceleration = UserAcceleration(x: 1, y: 1, z: 1)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, acceleration.x / 2 + acceleration.y / 2)
        XCTAssertEqual(result.y, acceleration.y / 2 - acceleration.x / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    func testConversionAxesByYawCalculateBottomRightSectionAcceleration() {
        let yaw = -2.25
        let acceleration = UserAcceleration(x: 1, y: 1, z: 1)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, acceleration.y / 2 - acceleration.x / 2)
        XCTAssertEqual(result.y, -acceleration.x / 2 - acceleration.y / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    func testConversionAxesByYawCalculateBottomLeftSectionAcceleration() {
        let yaw = 2.25
        let acceleration = UserAcceleration(x: 1, y: 1, z: 1)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, -acceleration.x / 2 - acceleration.y / 2)
        XCTAssertEqual(result.y, -acceleration.y / 2 + acceleration.x / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    func testConversionAxesByYawCalculateTopLeftSectionAcceleration() {
        let yaw = 0.75
        let acceleration = UserAcceleration(x: 1, y: 1, z: 1)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, -acceleration.y / 2 + acceleration.x / 2)
        XCTAssertEqual(result.y, acceleration.x / 2 + acceleration.y / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    func testConversionAxesByPitchCalculateTopRightSectionAcceleration() {
        let pitch = -0.75
        let gravity = -1.0
        let acceleration = UserAcceleration(x: 1, y: 1, z: 1)
        
        let result = sut.conversionAxes(byPitch: pitch, withAcceleration: acceleration, andWithGravityZ: gravity)
        
        XCTAssertEqual(result.x, acceleration.x)
        XCTAssertEqual(result.y, acceleration.y / 2 - acceleration.z / 2)
        XCTAssertEqual(result.z, acceleration.z / 2 + acceleration.y / 2)
    }
}
