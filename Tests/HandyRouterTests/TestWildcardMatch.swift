//
//  TestWildcardMatch.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/23.
//

import XCTest
@testable import HandyRouter

final class TestWildcardMatch: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B"] , availablePath: ["A", "*"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "B", "C"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "*", "C"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "B", "*"]))

        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "*", "C"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "*", "*"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "B", "*"]))

        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "*"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "C"]))

        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "*"]))
        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "*", "*"]))

        XCTAssertTrue(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "B", "C"]))
        
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["X", "B", "C"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "Y", "C"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "B", "Z"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["X", "Y", "Z"]))
        
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "Y", "C"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "B", "Z"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["*", "Y", "Z"]))
        
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["X", "*", "C"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "*", "Z"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["X", "*", "Z"]))
        
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["X", "B", "*"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["A", "Y", "*"]))
        XCTAssertFalse(Validator.matchWildcardPath(urls: ["A", "B", "C"], availablePath: ["X", "Y", "*"]))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
