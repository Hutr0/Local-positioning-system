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

    override func setUpWithError() throws {
        sut = MovementAnalysisManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetNewPositionWorksCorrecly() {
        let coordinates = CLLocation(latitude: 0, longitude: 0)
        let currentPosition = Position(coordinates: coordinates, speedX: 0, speedZ: 0)
        let time = 1.0
        
        let motionZ = MotionData(rotationRate: RotationRate(first: 0, second: 0, fird: 0),
                                 attitude: Attitude(first: 0, second: 0, fird: 0),
                                 userAcceleration: UserAcceleration(x: 0, y: 0, z: -10),
                                 gravity: Gravity(first: 0, second: 0, fird: 0))
        let resultZ = sut.getNewPosition(currentPosition: currentPosition, motion: motionZ, time: time)
        
        let motionX = MotionData(rotationRate: RotationRate(first: 0, second: 0, fird: 0),
                                 attitude: Attitude(first: 0, second: 0, fird: 0),
                                 userAcceleration: UserAcceleration(x: -10, y: 0, z: 0),
                                 gravity: Gravity(first: 0, second: 0, fird: 0))
        let resultX = sut.getNewPosition(currentPosition: currentPosition, motion: motionX, time: time)
        
        XCTAssertEqual(resultX.coordinates.coordinate.longitude, 5)
        XCTAssertEqual(resultX.coordinates.coordinate.latitude, 0)
        
        XCTAssertEqual(resultZ.coordinates.coordinate.latitude, 5)
        XCTAssertEqual(resultZ.coordinates.coordinate.longitude, 0)
    }
}
