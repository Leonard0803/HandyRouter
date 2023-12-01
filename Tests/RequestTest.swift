//
//  RequestTest.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/16.
//

import Foundation
import XCTest
@testable import HandyRouter

final class RequestTest: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParse() throws {
        let url1 = "https://xxx.xx.xx/path1/path2?key1=value1&key2=value2#fragment?fragmentKey1=fragmentValue1&fragmentKey2=fragmentValue2"
        let request1 = Request.init(url: url1, additionalParameter: [:], option: [])
        XCTAssertEqual(request1.pathComponents, ["path1", "path2#fragment"])
        XCTAssertEqual(request1.parameters["key1"] as! String, "value1")
        XCTAssertEqual(request1.parameters["key2"] as! String, "value2")
        XCTAssertEqual(request1.parameters["fragmentKey1"] as! String, "fragmentValue1")
        XCTAssertEqual(request1.parameters["fragmentKey2"] as! String, "fragmentValue2")
    }
}
