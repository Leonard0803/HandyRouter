//
//  ResourceTest.swift
//  
//
//  Created by 邹贤琳 on 2023/12/1.
//

import XCTest
import HandyRouter

final class ResourceTest: XCTestCase {

    func testResource() {
        // given
        let url = URL.init(string: "https://www.xxxxxx.com")
        
        // then
        XCTAssertEqual(url?.url, url)
    }
}
