//
//  ResponstTest.swift
//  
//
//  Created by 邹贤琳 on 2023/12/1.
//

import XCTest
import HandyRouter

final class ResponstTest: XCTestCase {

    func testResponseEqual() {
        
        // given
        let response1 = Response(match: true, parameters: ["key": "value"])
        let response2 = Response(match: true, parameters: ["key": "value"])
        let response3 = Response(match: false, parameters: ["key": "value"])
        let response4 = Response(match: true, parameters: ["key": "value",
                                                           "key2": "value2"])
        // then
        XCTAssertEqual(response1, response2)
        XCTAssertNotEqual(response1, response3)
        XCTAssertNotEqual(response1, response4)
    }

}
