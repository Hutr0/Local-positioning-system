//
//  AlertManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 22.05.2022.
//

import XCTest
@testable import Local_positioning_system

class AlertManagerTests: XCTestCase {

    var vc: MainViewController!
    
    override func setUpWithError() throws {
        vc = (UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainViewController)
        
        UIWindow().rootViewController = vc
    }

    override func tearDownWithError() throws {
        vc = nil
    }
    
//    func testAlertHasTitle() {
//        AlertManager.showAlert(title: "Test Title", message: "")
//        
//        XCTAssertTrue(vc.presentedViewController is UIAlertController)
//        XCTAssertEqual(vc.presentedViewController?.title, "Test Title")
//    }
}
