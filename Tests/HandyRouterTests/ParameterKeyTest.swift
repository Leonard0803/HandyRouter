//
//  ParameterKeyTest.swift
//  
//
//  Created by 邹贤琳 on 2023/12/1.
//

import XCTest
import HandyRouter

final class ParameterKeyTest: XCTestCase {

    func testParameterKeyHasValue() {
        // give
        let dict: [ParameterKey: String] = [.url: "url",
                                            .page: "page"]
        
        // when
        let page = dict.toPage
        let url = dict.toUrl
        
        // then
        XCTAssertEqual(page, "page")
        XCTAssertEqual(url, "url")
    }
    
    func testParameterKeyHasNotValue() {
        // give
        let dict: [ParameterKey: String] = ["key": "value"]
        
        // when
        let page = dict.toPage
        let url = dict.toUrl
        
        // then
        XCTAssertEqual(page, "")
        XCTAssertEqual(url, "")
    }

}
