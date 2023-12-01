//
//  URLComponentTest.swift
//  
//
//  Created by 邹贤琳 on 2023/12/1.
//

import XCTest
import HandyRouter

final class URLComponentTest: XCTestCase {

    func testComponentContainsArrayParameter() {
        // given
        let url = URLComponents.init(string: "https://example/?key=1&key=2&key=3&key1=4")
        
        // when
        let param = url?.route_queryParameters() as? [String: Any]
        let arrayResult = param?["key"] as? [String]
        let stringResult = param?["key1"] as? String
        
        // then
        XCTAssertEqual(arrayResult?[0], "1")
        XCTAssertEqual(arrayResult?[1], "2")
        XCTAssertEqual(arrayResult?[2], "3")
        XCTAssertEqual(stringResult, "4")
    }

}
