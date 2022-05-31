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
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetNewCoordinatesSpeed() {
        let position = Position(x: 0, y: 0, z: 0, speedX: 1, speedY: 1, speedZ: 1)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let gravity = Gravity(x: 0, y: 0, z: 0)
        
        let roll = 0.0
        let pitch = 0.0
        let yaw = 0.0
        
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity.z)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 1, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 1, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 1, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
    }
    
    // MARK: - Method 'getNewCoordinates' by all parameters
    
    func testGetNewCoordinatesByAllParametersWorksCorrectlyFirst() {
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let gravity = Gravity(x: 0, y: 0, z: 0)
        
        let roll = 0.0
        let pitch = 0.0
        let yaw = 0.0
        
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity.z)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
    }
    
    func testGetNewCoordinatesByAllParametersWorksCorrectlySecond() {
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let gravity = Gravity(x: 0, y: 0, z: 0)
        
        let roll = 0.75
        let pitch = 0.75
        let yaw = 0.75
        
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity.z)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
    }
    
    func testGetNewCoordinatesByAllParametersWorksCorrectlyThird() {
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let gravity = Gravity(x: 0, y: 0, z: 0)
        
        let roll = -0.75
        let pitch = -0.75
        let yaw = -0.75
        
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity.z)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
    }
    
    // MARK: - Method 'getNewCoordinates' by Roll
    
    func testGetNewCoordinatesByRollWorksCorrectlyFirst() {
        let roll = 0.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 5, y: 8, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByRollWorksCorrectlySecond() {
        let roll = 0.75
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByRollWorksCorrectlyThird() {
        let roll = 1.5
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertLessThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByRollWorksCorrectlyFourth() {
        let roll = 2.25
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 0.0)
        
        XCTAssertLessThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByRollWorksCorrectlyFifth() {
        let roll = 3.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 12, y: 13, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, -4.905)
        
        XCTAssertLessThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByRollWorksCorrectlySixth() {
        let roll = -2.25
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, -4.905)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByRollWorksCorrectlySeventh() {
        let roll = -1.5
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, -4.905)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByRollWorksCorrectlyEighth() {
        let roll = -0.75
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: 0, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byRoll: roll, withAcceleration: axes)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, x)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 0.0)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    // MARK: - Method 'getNewCoordinates' by Pitch
    
    func testGetNewCoordinatesByPitchWorksCorreclyFirst() {
        let pitch = 0.0
        let gravity = -1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByPitchWorksCorreclySecond() {
        let pitch = -0.75
        let gravity = -1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertLessThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByPitchWorksCorreclyThird() {
        let pitch = -1.5
        let gravity = -1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertLessThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByPitchWorksCorreclyForth() {
        let pitch = -0.75
        let gravity = 1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertLessThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByPitchWorksCorreclyFifth() {
        let pitch = 0.0
        let gravity = 1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertLessThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByPitchWorksCorreclySixth() {
        let pitch = 0.75
        let gravity = 1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByPitchWorksCorreclySeventh() {
        let pitch = 1.5
        let gravity = 1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByPitchWorksCorreclyEighth() {
        let pitch = 0.75
        let gravity = 1.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: pitch, yaw: 0),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: gravity))
        
        let newYaw = sut.getNewYaw(0.0, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes = sut.conversionAxes(byPitch: pitch, withAcceleration: axes, andWithGravityZ: gravity)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        let z = PhysMathManager.getNewPointValue(initialP: position.z, initialSpeed: 0, time: 1, acceleration: axes.z)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        print("X: \(result.x)")
        print("Y: \(result.y)")
        print("Z: \(result.z)")
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, z)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.z, 0)
    }
    
    // MARK: - Method 'getNewCoordinates' by Yaw
    
    func testGetNewCoordinatesByYawWorksCorreclyFirst() {
        let yaw = 0.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: 0, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        let y = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration).y * 9.81
        let pointY = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(result.x, 4.905)
        XCTAssertEqual(result.y, pointY)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByYawWorksCorreclySecond() {
        let yaw = 0.75
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: 0, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(NSString(format:"%.14f", result.x), NSString(format: "%.14f", x))
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertLessThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByYawWorksCorreclyThird() {
        let yaw = 1.5
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: 0, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(NSString(format:"%.15f", result.x), NSString(format: "%.15f", x))
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByYawWorksCorreclyFourth() {
        let yaw = 3.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: 0, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(NSString(format:"%.15f", result.x), NSString(format: "%.15f", x))
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertLessThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByYawWorksCorreclyFifth() {
        let yaw = -3.0
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: 0, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(NSString(format:"%.15f", result.x), NSString(format: "%.15f", x))
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertLessThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByYawWorksCorreclySixth() {
        let yaw = -2.25
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: 0, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(NSString(format:"%.15f", result.x), NSString(format: "%.15f", x))
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertLessThanOrEqual(result.x, 0)
        XCTAssertLessThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    func testGetNewCoordinatesByYawWorksCorreclySeventh() {
        let yaw = -1.5
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 1, y: 1, z: 1)
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: 0, pitch: 0, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: Gravity(x: 0, y: 0, z: 0))
        
        let newYaw = sut.getNewYaw(yaw, fromHeading: 0)
        var axes = sut.conversionAxes(byYaw: newYaw, withAcceleration: userAcceleration)
        axes.x = axes.x * 9.81
        axes.y = axes.y * 9.81
        axes.z = axes.z * 9.81
        let x = PhysMathManager.getNewPointValue(initialP: position.x, initialSpeed: 0, time: 1, acceleration: axes.x)
        let y = PhysMathManager.getNewPointValue(initialP: position.y, initialSpeed: 0, time: 1, acceleration: axes.y)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(NSString(format:"%.15f", result.x), NSString(format: "%.15f", x))
        XCTAssertEqual(result.y, y)
        XCTAssertEqual(result.z, 4.905)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertLessThanOrEqual(result.y, 0)
        XCTAssertGreaterThanOrEqual(result.z, 0)
    }
    
    // MARK: - Method 'getNewYaw'
    
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
    
    // MARK: - Method 'conversionAxes' by Yaw
    
    func testConversionAxesByYawCalculateTopRightSectionAcceleration() {
        let yaw = -0.75
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, acceleration.x / 2 + acceleration.y / 2)
        XCTAssertEqual(result.y, acceleration.y / 2 - acceleration.x / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    func testConversionAxesByYawCalculateBottomRightSectionAcceleration() {
        let yaw = -2.25
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, acceleration.y / 2 - acceleration.x / 2)
        XCTAssertEqual(result.y, -acceleration.x / 2 - acceleration.y / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    func testConversionAxesByYawCalculateBottomLeftSectionAcceleration() {
        let yaw = 2.25
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, -acceleration.x / 2 - acceleration.y / 2)
        XCTAssertEqual(result.y, -acceleration.y / 2 + acceleration.x / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    func testConversionAxesByYawCalculateTopLeftSectionAcceleration() {
        let yaw = 0.75
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byYaw: yaw, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, -acceleration.y / 2 + acceleration.x / 2)
        XCTAssertEqual(result.y, acceleration.x / 2 + acceleration.y / 2)
        XCTAssertEqual(result.z, acceleration.z)
    }
    
    // MARK: - Method 'conversionAxes' by Pitch
    
    func testConversionAxesByPitchCalculateBottomRightSectionAcceleration() {
        let pitch = -0.75
        let gravity = -1.0
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byPitch: pitch, withAcceleration: acceleration, andWithGravityZ: gravity)
        
        XCTAssertEqual(result.x, acceleration.x)
        XCTAssertEqual(result.y, acceleration.y / 2 - acceleration.z / 2)
        XCTAssertEqual(result.z, acceleration.z / 2 + acceleration.y / 2)
    }
    
    func testConversionAxesByPitchCalculateBottomLeftSectionAcceleration() {
        let pitch = -0.75
        let gravity = 1.0
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byPitch: pitch, withAcceleration: acceleration, andWithGravityZ: gravity)
        
        XCTAssertEqual(result.x, acceleration.x)
        XCTAssertEqual(result.y, -acceleration.z / 2 - acceleration.y / 2)
        XCTAssertEqual(result.z, acceleration.y / 2 - acceleration.z / 2)
    }
    
    func testConversionAxesByPitchCalculateTopLeftSectionAcceleration() {
        let pitch = 0.75
        let gravity = 1.0
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byPitch: pitch, withAcceleration: acceleration, andWithGravityZ: gravity)
        
        XCTAssertEqual(result.x, acceleration.x)
        XCTAssertEqual(result.y, -acceleration.y / 2 + acceleration.z / 2)
        XCTAssertEqual(result.z, -acceleration.z / 2 - acceleration.y / 2)
    }
    
    func testConversionAxesByPitchCalculateTopRightSectionAcceleration() {
        let pitch = 0.75
        let gravity = -1.0
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byPitch: pitch, withAcceleration: acceleration, andWithGravityZ: gravity)
        
        XCTAssertEqual(result.x, acceleration.x)
        XCTAssertEqual(result.y, acceleration.z / 2 + acceleration.y / 2)
        XCTAssertEqual(result.z, -acceleration.y / 2 + acceleration.z / 2)
    }
    
    // MARK: - Method 'conversionAxes' by Roll
    
    func testConversionAxesByRollCalculateTopRightSectionAcceleration() {
        let pitch = 0.75
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byRoll: pitch, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, acceleration.x / 2 - acceleration.z / 2)
        XCTAssertEqual(result.y, acceleration.y)
        XCTAssertEqual(result.z, acceleration.z / 2 + acceleration.x / 2)
    }
    
    func testConversionAxesByRollCalculateBottomRightSectionAcceleration() {
        let pitch = 2.25
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byRoll: pitch, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, -acceleration.z / 2 - acceleration.x / 2)
        XCTAssertEqual(result.y, acceleration.y)
        XCTAssertEqual(result.z, acceleration.x / 2 - acceleration.z / 2)
    }
    
    func testConversionAxesByRollCalculateBottomLeftSectionAcceleration() {
        let pitch = -2.25
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byRoll: pitch, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, -acceleration.x / 2 + acceleration.z / 2)
        XCTAssertEqual(result.y, acceleration.y)
        XCTAssertEqual(result.z, -acceleration.z / 2 - acceleration.x / 2)
    }
    
    func testConversionAxesByRollCalculateTopLeftSectionAcceleration() {
        let pitch = -0.75
        let acceleration = UserAcceleration(x: 5, y: 4, z: 3)
        
        let result = sut.conversionAxes(byRoll: pitch, withAcceleration: acceleration)
        
        XCTAssertEqual(result.x, acceleration.z / 2 + acceleration.x / 2)
        XCTAssertEqual(result.y, acceleration.y)
        XCTAssertEqual(result.z, -acceleration.x / 2 + acceleration.z / 2)
    }
    
    func testGetNewCoordinatesReturnsCurrentCoordinatesIfAccelerationIsLow() {
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 0.01, y: 0.01, z: 0.01)
        let gravity = Gravity(x: 0, y: 0, z: 0)
        
        let roll = 0.0
        let pitch = 0.0
        let yaw = 0.0
        
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(result.x, position.x)
        XCTAssertEqual(result.y, position.y)
        XCTAssertEqual(result.z, position.z)
    }
    
    func testGetNewCoordinatesReturnsCurrentSpeedIfAccelerationIsLow() {
        let position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        let userAcceleration = UserAcceleration(x: 0.01, y: 0.01, z: 0.01)
        let gravity = Gravity(x: 0, y: 0, z: 0)
        
        let roll = 0.0
        let pitch = 0.0
        let yaw = 0.0
        
        let motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        let result = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        
        XCTAssertEqual(result.speedX, position.speedX)
        XCTAssertEqual(result.speedY, position.speedY)
        XCTAssertEqual(result.speedZ, position.speedZ)
    }
    
    func testGetNewCoordinatesBackAcceleration() {
        var result: [Position] = []
        
        var position = Position(x: 0, y: 0, z: 0, speedX: 0, speedY: 0, speedZ: 0)
        var userAcceleration = UserAcceleration(x: 10, y: 10, z: 10)
        let gravity = Gravity(x: 0, y: 0, z: 0)
        
        let roll = 0.0
        let pitch = 0.0
        let yaw = 0.0
        
        var motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        position = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        result.append(position)
        
        userAcceleration = UserAcceleration(x: -1, y: -1, z: -1)
        
        motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        position = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        result.append(position)
        
        userAcceleration = UserAcceleration(x: -2, y: -2, z: -2)
        
        motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        position = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        result.append(position)
        
        userAcceleration = UserAcceleration(x: -10, y: -10, z: -10)
        
        motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        position = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        result.append(position)
        
        userAcceleration = UserAcceleration(x: -5, y: -5, z: -5)
        
        motion = MotionData(rotationRate: RotationRate(x: 0, y: 0, z: 0),
                                attitude: Attitude(roll: roll, pitch: pitch, yaw: yaw),
                                userAcceleration: userAcceleration,
                                gravity: gravity)
        
        position = sut.getNewCoordinates(currentPosition: position, motion: motion, time: 1, heading: 0)
        result.append(position)
        
        XCTAssertEqual(result[4].x, 49.050000000000004)
        XCTAssertEqual(result[4].y, 9.079214089918311)
        XCTAssertEqual(result[4].z, 49.050000000000004)
    }
}
