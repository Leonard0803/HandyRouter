//
//  ExpandOptionalTest.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/27.
//

import XCTest
@testable import HandyRouter

final class ExpandOptionalTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExpandA() throws {
        let targetA = "/(A)/B/C"
        let resultA = targetA.route_scanOptionalPaths()
        XCTAssertTrue(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertFalse(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertFalse(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandB() {
        let targetA = "/A/(B)/C"
        let resultA = targetA.route_scanOptionalPaths()
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertTrue(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertFalse(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandC() {
        let targetA = "/A/(B/C)"
        let resultA = targetA.route_scanOptionalPaths()
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertTrue(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertTrue(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandD() {
        let targetA = "/A(/B/C)"
        let resultA = targetA.route_scanOptionalPaths()
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertTrue(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertTrue(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandE() {
        let targetA = "/A/()/B/C"
        let resultA = targetA.route_scanOptionalPaths()
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertFalse(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertFalse(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
}
