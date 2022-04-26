//
//  MovementAnalysisTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 26.04.2022.
//

import XCTest
@testable import Local_positioning_system

class MovementAnalysisManagerTests: XCTestCase {
    
    var sut: MovementAnalysisManager!

    override func setUpWithError() throws {
        sut = MovementAnalysisManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
