//
//  RouterTest.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/27.
//

import XCTest
@testable import HandyRouter

enum RouterTestModuleJumperA: String, Jumper {
    static func jump(to page: Self, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        print("RouterTestModuleJumperA handle")
        return true
    }
    
    static var module: String {
        return "scheme/A"
    }
    
    case page
}


enum RouterTestModuleJumperB: String, Jumper {
    static func jump(to page: Self, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        print("RouterTestModuleJumperB handle")
        return true
    }
    
    static var module: String {
        return "scheme/B"
    }
    
    case page
}

final class RouterTest: XCTestCase {

    func testExample() throws {
        Router.default.register(jumper: RouterTestModuleJumperB.self, scheme: "schemeB")
        let resultA = Router.default.canRoute(to: "schemeA://www.easyRoute.com/scheme/B/page")
        XCTAssertFalse(resultA)
        // register it to default route as a fall back option
        Router.default.register(jumper: RouterTestModuleJumperB.self)
        let resultB = Router.default.canRoute(to: "schemeA://www.easyRoute.com/scheme/B/page")
        XCTAssertTrue(resultB)
        Router.default.unRegister(jumper: RouterTestModuleJumperB.self, scheme: "schemeB")
        Router.default.unRegister(jumper: RouterTestModuleJumperB.self)
    }
    
    func testUnregister() {
        Router.default.register(jumper: RouterTestModuleJumperB.self)
        let resultA = Router.default.canRoute(to: "schemeB://www.easyRoute.com/scheme/B/page")
        XCTAssertTrue(resultA)
        Router.default.unRegister(jumper: RouterTestModuleJumperB.self)
        let resultB = Router.default.canRoute(to: "schemeB://www.easyRoute.com/scheme/B/page")
        XCTAssertFalse(resultB)
    }
}
