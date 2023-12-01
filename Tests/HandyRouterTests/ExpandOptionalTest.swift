//
//  ExpandOptionalTest.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/27.
//

import XCTest
@testable import HandyRouter

final class ExpandOptionalTest: XCTestCase {

    func testExpandA() throws {
        // given
        let targetA = "/(A)/B/C"
        
        // when
        let resultA = targetA.route_scanOptionalPaths()
        
        // then
        XCTAssertTrue(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertFalse(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertFalse(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandB() {
        // given
        let targetA = "/A/(B)/C"
        
        // when
        let resultA = targetA.route_scanOptionalPaths()
        
        // then
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertTrue(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertFalse(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandC() {
        // given
        let targetA = "/A/(B/C)"
        
        // when
        let resultA = targetA.route_scanOptionalPaths()
        
        // then
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertTrue(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertTrue(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandD() {
        // given
        let targetA = "/A(/B/C)"
        
        // when
        let resultA = targetA.route_scanOptionalPaths()
        
        // then
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertTrue(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertTrue(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
    
    func testExpandE() {
        // given
        let targetA = "/A/()/B/C"
        
        // when
        let resultA = targetA.route_scanOptionalPaths()
        
        // then
        XCTAssertFalse(resultA[0].isOptional)
        XCTAssertEqual(resultA[0].path, "A")
        XCTAssertFalse(resultA[1].isOptional)
        XCTAssertEqual(resultA[1].path, "B")
        XCTAssertFalse(resultA[2].isOptional)
        XCTAssertEqual(resultA[2].path, "C")
    }
}
