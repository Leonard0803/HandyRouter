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
        // given
        Router.default.register(jumper: RouterTestModuleJumperB.self, scheme: "schemeB")
        
        // when
        let resultA = Router.default.canRoute(to: "schemeA://www.easyRoute.com/scheme/B/page")
        
        // then
        XCTAssertFalse(resultA)
        
        // given
        // register it to default route as a fall back option
        Router.default.register(jumper: RouterTestModuleJumperB.self)
        
        // when
        let resultB = Router.default.canRoute(to: "schemeA://www.easyRoute.com/scheme/B/page")
        
        // then
        XCTAssertTrue(resultB)
        
        // end
        Router.default.unRegister(jumper: RouterTestModuleJumperB.self, scheme: "schemeB")
        Router.default.unRegister(jumper: RouterTestModuleJumperB.self)
    }
    
    func testUnregister() {
        // given
        Router.default.register(jumper: RouterTestModuleJumperB.self)
        
        // when
        let resultA = Router.default.canRoute(to: "schemeB://www.easyRoute.com/scheme/B/page")
        
        // then
        XCTAssertTrue(resultA)
        Router.default.unRegister(jumper: RouterTestModuleJumperB.self)
        
        // when
        let resultB = Router.default.canRoute(to: "schemeB://www.easyRoute.com/scheme/B/page")
        
        // then
        XCTAssertFalse(resultB)
    }
    
    func testSearchRoute() {
        // give
        let result = Router.default.searchRoutes(scheme: "notExist")
        
        // then
        XCTAssertIdentical(result, Router.default.defaultRoute)
    }
}
