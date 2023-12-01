//
//  RoutesTest.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/27.
//

import XCTest
@testable import HandyRouter

enum RouteJumper: String, Jumper {
    
    static func jump(to page: RouteJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .A:
            print("pageA handle")
            return true
        case .B:
            print("pageB handle")
            return true
        }
    }
    
    case A, B
    
    static var module: String {
        return "routeJumper"
    }
}

enum OptionalModuleJumper: String, Jumper {
    static func jump(to page: OptionalModuleJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        print("page handle")
        return true
    }
    case page
    
    static var module: String {
        return "A/(B)/(C)"
    }
}

enum WildcardModuleJumperA: String, Jumper {
    
    static func jump(to page: WildcardModuleJumperA, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        return true
    }
    case page
    
    static var module: String {
        return "wildcardA/*"
    }
}

enum WildcardModuleJumperB: String, Jumper {
    
    static func jump(to page: WildcardModuleJumperB, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        return true
    }
    case page
    
    static var module: String {
        return "*/wildcardB/*"
    }
}

struct WhiteListInterceptor: RouteInterceptor {
    let whiteList = ["www.xxx.com"]
    func perform(parameters: [String : Any]) -> RouteInterceptorState {
        let url = parameters["__URL__"] as? String
        guard let url = url else { return .pass }
        var state: RouteInterceptorState = .reject
        whiteList.forEach {
            if url.contains($0) {
                state = .pass
                return
            }
        }
        return state
    }
}

final class RoutesTest: XCTestCase {
    
   
    func testOptionalPath() throws {
        Router.default.register(jumper: OptionalModuleJumper.self)
        let targetURLA = "https://www.xxx.com/A/page"
        let resultA = Router.default.canRoute(to: targetURLA)
        let targetURLB = "https://www.xxx.com/A/B/page"
        let resultB = Router.default.canRoute(to: targetURLB)
        let targetURLC = "https://www.xxx.com/A/B/C/page"
        let resultC = Router.default.canRoute(to: targetURLC)
        let targetURLD = "https://www.xxx.com/A/C/page"
        let resultD = Router.default.canRoute(to: targetURLD)
        let targetURLE = "https://www.xxx.com/B/C/page"
        let resultE = Router.default.canRoute(to: targetURLE)
        XCTAssertTrue(resultA)
        XCTAssertTrue(resultB)
        XCTAssertTrue(resultC)
        XCTAssertTrue(resultD)
        XCTAssertFalse(resultE)
        Router.default.unRegister(jumper: OptionalModuleJumper.self)
    }
    
    func testTreatHostAsPath() {
        Router.default.register(jumper: RouteJumper.self, scheme: "scheme", option: [.treatHostAsPathComponent])
        let targetURL = "scheme://routeJumper/A"
        let result = Router.default.canRoute(to: targetURL)
        XCTAssertTrue(result)
        Router.default.register(jumper: RouteJumper.self, scheme: "schemeA", option: [])
        let targetURLA = "schemeA://routeJumper/A"
        let resultA = Router.default.canRoute(to: targetURLA)
        XCTAssertFalse(resultA)
    }
}
