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

    func testInitialize() {
        // given
        let url1 = "https://xxx.xx.xx/path1/path2?key1=value1&key2=value2#fragment?fragmentKey1=fragmentValue1&fragmentKey2=fragmentValue2"
        
        // when
        let request1 = Request.init(url: url1, additionalParameter: [:], option: [])
        
        // then
        XCTAssertEqual(request1.pathComponents, ["path1", "path2#fragment"])
        XCTAssertEqual(request1.parameters["key1"] as! String, "value1")
        XCTAssertEqual(request1.parameters["key2"] as! String, "value2")
        XCTAssertEqual(request1.parameters["fragmentKey1"] as! String, "fragmentValue1")
        XCTAssertEqual(request1.parameters["fragmentKey2"] as! String, "fragmentValue2")
    }
    
    func testHostIsAllBlankSpaces() {
        // given
        let url = "http://%20"
        
        // when
        let request = Request.init(url: url, additionalParameter: [:], option: [])
        
        // then
        XCTAssertEqual(request.pathComponents, [""])
    }
    
    func testInitializeWithTreatHostAsPath() {
        // given
        let url = "http://ho%20st/path"
        
        // when
        let request = Request.init(url: url, additionalParameter: [:], option: [.treatHostAsPathComponent])
        
        // then
        XCTAssertEqual(request.pathComponents[0], "ho st")
        XCTAssertEqual(request.pathComponents[1], "path")
    }
    
    func testInitializeWithFragmentIsParam() {
        // given
        let url = "http://host/path/page#key=value"
        
        // when
        let request = Request.init(url: url, additionalParameter: [:], option: [])
        
        // then
        XCTAssertEqual(request.parameters["key"] as! String, "value")
        XCTAssertEqual(request.pathComponents, ["path", "page"])
    }
    
    func testInitializeWithFragmentWithParam() {
        // given
        let url = "http://host/path/page#fragment?key=value"
        
        // when
        let request = Request.init(url: url, additionalParameter: [:], option: [])
        
        // then
        XCTAssertEqual(request.parameters["key"] as! String, "value")
        XCTAssertEqual(request.pathComponents, ["path", "page#fragment"])
    }
}
