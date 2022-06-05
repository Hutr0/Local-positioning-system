//
//  UserManagerTests.swift
//  Local positioning systemTests
//
//  Created by Леонид Лукашевич on 28.04.2022.
//

import XCTest
import CoreLocation
@testable import Local_positioning_system

class UserManagerTests: XCTestCase {

    var sut: UserManager!
    
    override func setUpWithError() throws {
        sut = UserManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetUserCoordinatesForMapReturnsNotNil() {
        XCTAssertNotNil(sut.getUserCoordinatesForMap(mapWidth: 0, mapHeight: 0, coordinatesOfUser: CLLocationCoordinate2D()))
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly1() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = BuildingCoordinates().rightTop
        
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinatesOfUser: coordinates)
        
        XCTAssertGreaterThanOrEqual(result.x, mapWidth - 5)
        XCTAssertGreaterThanOrEqual(result.y, mapHeight - 5)
        XCTAssertLessThanOrEqual(result.x, mapWidth)
        XCTAssertLessThanOrEqual(result.y, mapHeight)
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly2() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = BuildingCoordinates().leftBottom
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinatesOfUser: coordinates)
        
        XCTAssertGreaterThanOrEqual(result.x, 0)
        XCTAssertGreaterThanOrEqual(result.y, 0)
        XCTAssertLessThanOrEqual(result.x, 5)
        XCTAssertLessThanOrEqual(result.y, 5)
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly3() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = CLLocationCoordinate2D(latitude: 55.67239468839017, longitude: 37.47906302533583)
        
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinatesOfUser: coordinates)
        
        XCTAssertEqual(result.x, 855.0205833698863)
        XCTAssertEqual(result.y, 571.8172316649066)
    }
    
    func testGetUserCoordinatesForMapWorksCorrectly4() {
        let mapWidth: CGFloat = 1400
        let mapHeight: CGFloat = 900
        let coordinates = CLLocationCoordinate2D(latitude: 55.67301506732467, longitude: 37.478791533281635)
        
        let result = sut.getUserCoordinatesForMap(mapWidth: mapWidth, mapHeight: mapHeight, coordinatesOfUser: coordinates)
        
        XCTAssertEqual(result.x, 31.041253945410062)
        XCTAssertEqual(result.y, 0)
    }
    
//    func testGetDifferenceBetweenFirst() {
//        let fp = 10.0
//        let sp = 5.0
//
//        let result = sut.getDifferenceBetween(firstPoint: fp, secondPoint: sp)
//
//        XCTAssertEqual(result, 5)
//    }
//
//    func testGetDifferenceBetweenSecond() {
//        let fp = 10.0
//        let sp = 5.0
//
//        let result = sut.getDifferenceBetween(firstPoint: sp, secondPoint: fp)
//
//        XCTAssertEqual(result, 5)
//    }
//
//    func testGetParameterWidth1() {
//        let point = CGPoint(x: 2.5, y: 2.5)
//        let topPoint = CGPoint(x: 5, y: 5)
//        let bottomPoint = CGPoint(x: 4, y: 0)
//        let backPoint = CGPoint(x: 0, y: 6)
//
//        let result = sut.getParameter(pointToSide: point.x,
//                                      pointNotToSide: point.y,
//                                      minDistanceToSide: min(topPoint.x, bottomPoint.x),
//                                      maxDistanceToSide: max(topPoint.x, bottomPoint.x),
//                                      minDistanceNotToSide: min(topPoint.y, bottomPoint.y),
//                                      maxDistanceNotToSide: max(topPoint.y, bottomPoint.y),
//                                      nearestPointNotToSide: backPoint.y)
//
//        XCTAssertEqual(result, 2.2)
//    }
//
//    func testGetParameterWidth2() {
//        let point = CGPoint(x: 0, y: 6)
//        let topPoint = CGPoint(x: 5, y: 5)
//        let bottomPoint = CGPoint(x: 4, y: 0)
//        let backPoint = CGPoint(x: 0, y: 6)
//
//        let result = sut.getParameter(pointToSide: point.x,
//                                      pointNotToSide: point.y,
//                                      minDistanceToSide: min(topPoint.x, bottomPoint.x),
//                                      maxDistanceToSide: max(topPoint.x, bottomPoint.x),
//                                      minDistanceNotToSide: min(topPoint.y, bottomPoint.y),
//                                      maxDistanceNotToSide: max(topPoint.y, bottomPoint.y),
//                                      nearestPointNotToSide: backPoint.y)
//
//        XCTAssertEqual(result, 2.2)
//    }
//
//    func testGetParameterHeight1() {
//        let point = CGPoint(x: 1, y: 6)
//        let leftPoint = CGPoint(x: 1, y: 6)
//        let rightPoint = CGPoint(x: 5, y: 5)
//        let backPoint = CGPoint(x: 4, y: 0)
//
//        let result = sut.getParameter(pointToSide: point.y,
//                                      pointNotToSide: point.x,
//                                      minDistanceToSide: min(leftPoint.y, rightPoint.y),
//                                      maxDistanceToSide: max(leftPoint.y, rightPoint.y),
//                                      minDistanceNotToSide: min(leftPoint.x, rightPoint.x),
//                                      maxDistanceNotToSide: max(leftPoint.x, rightPoint.x),
//                                      nearestPointNotToSide: backPoint.x)
//
//        XCTAssertEqual(result, 3.375)
//    }
//
//    func testA() {
//        let result = sut.getHeight(minPoint: CGPoint(x: 0, y: 3), maxPoint: CGPoint(x: 6, y: 4), point: CGPoint(x: 2.5, y: 2), leftPoint: CGPoint(x: 0, y: 3), rightPoint: CGPoint(x: 5, y: 4))
//
//        XCTAssertEqual(result, 1.4766704288891124)
//    }
//
//    func testB() {
//        let result = sut.getHeight(minPoint: CGPoint(x: 0, y: 3), maxPoint: CGPoint(x: 6, y: 4), point: CGPoint(x: 0, y: 3), leftPoint: CGPoint(x: 0, y: 3), rightPoint: CGPoint(x: 5, y: 4))
//
//        XCTAssertEqual(result, 0)
//    }
//
//    func testC() {
//        let result = sut.getHeight(minPoint: CGPoint(x: 0, y: 3), maxPoint: CGPoint(x: 6, y: 4), point: CGPoint(x: 5, y: 4), leftPoint: CGPoint(x: 0, y: 3), rightPoint: CGPoint(x: 5, y: 4))
//
//        XCTAssertEqual(result, 0)
//    }
}
