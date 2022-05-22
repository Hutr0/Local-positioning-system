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
}
