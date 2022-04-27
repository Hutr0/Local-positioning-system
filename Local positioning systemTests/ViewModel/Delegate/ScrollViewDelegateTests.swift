//
//  ScrollViewDelegateTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 27.04.2022.
//

import XCTest
@testable import Local_positioning_system

class ScrollViewDelegateTests: XCTestCase {

    var sut: ScrollViewDelegate!
    
    override func setUpWithError() throws {
        sut = ScrollViewDelegate(map: UIImageView())
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMapIsAssignedViaInitialization() {
        XCTAssertNotNil(sut.map)
    }
    
    func testViewForZoomingReturnsMap() {
        let map = UIImageView(image: UIImage(named: "mirea map"))
        sut = ScrollViewDelegate(map: map)
        
        let result = sut.viewForZooming(in: UIScrollView())
        
        XCTAssertEqual(map, result)
    }
    
    func testScrollViewDidZoomIsWorkingCorrectly() {
        let scrollView = UIScrollView()
        scrollView.delegate = sut
        
        let secondScrollView = UIScrollView()
        
        scrollView.bounds.size.width = 1.5
        scrollView.bounds.size.height = 1.5
        secondScrollView.bounds.size.width = 1.5
        secondScrollView.bounds.size.height = 1.5
        
        sut.scrollViewDidZoom(scrollView)
        
        let offsetX = max((secondScrollView.bounds.width - secondScrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((secondScrollView.bounds.height - secondScrollView.contentSize.height) * 0.5, 0)
        secondScrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        
        XCTAssertEqual(scrollView.contentInset, secondScrollView.contentInset)
    }
}
