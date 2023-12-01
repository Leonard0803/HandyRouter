//
//  TestRouterPage.swift
//  
//
//  Created by 邹贤琳 on 2023/12/1.
//

import XCTest
import HandyRouter

enum TestRouterPageJumper: String, RouterPage {
    
    case pageA = "Hello"
    
    static var module: String {
        "module"
    }
}

final class TestRouterPage: XCTestCase {

    func testRouterPagePath() {
        // given
        let page = TestRouterPageJumper.pageA
        
        // then
        XCTAssertEqual(page.page, "Hello")
    }
}
