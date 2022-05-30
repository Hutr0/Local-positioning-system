//
//  AlertManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 22.05.2022.
//

import XCTest
@testable import Local_positioning_system

class AlertManagerTests: XCTestCase {

    var sut: AlertManager!
    
    override func setUpWithError() throws {
        sut = AlertManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
