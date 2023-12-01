//
//  DictionaryExtensionTest.swift
//  
//
//  Created by 邹贤琳 on 2023/12/1.
//

import XCTest
import HandyRouter

final class DictionaryExtensionTest: XCTestCase {

    func testNotContainDecodePlusSymbol() {
        // given
        let dict: [String: Any] = ["key": "I+am+Value"]
        
        // when
        let newDict = dict.route_decodeParameter(option: [])
        
        // then
        XCTAssertEqual(dict["key"] as? String, newDict["key"] as? String)
    }
    
    func testDidContainDecodePlusSymbol() {
        // given
        let dict: [String: Any] = ["key": "I+am+Value"]
        
        // when
        let newDict = dict.route_decodeParameter(option: [.decodePlusSymbol])
        
        // then
        XCTAssertEqual(newDict["key"] as? String, "I am Value")
    }
    
    func testArrayValueNotContainDecodePlusSymbol() {
        // given
        let dict: [String: Any] = ["key": ["I+am+Value", "I+am+Value2"]]
        
        // when
        let newDict = dict.route_decodeParameter(option: [.decodePlusSymbol])
        
        // then
        let result = newDict["key"] as? Array<String>
        XCTAssertEqual(result?[0], "I am Value")
        XCTAssertEqual(result?[1], "I am Value2")
        
    }
}
