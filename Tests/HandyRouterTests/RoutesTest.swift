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

class WhiteListInterceptor: RouteInterceptor {
    let whiteList = ["www.whitelist.com"]
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

class PassInterceptor: RouteInterceptor {
    func perform(parameters: [String : Any]) -> RouteInterceptorState {
        return .pass
    }
}

class NotPassInterceptor: RouteInterceptor {
    func perform(parameters: [String : Any]) -> RouteInterceptorState {
        return .reject
    }
}


final class RoutesTest: XCTestCase {
    
    func testOptionalPath() throws {
        // given
        Router.shared.register(jumper: OptionalModuleJumper.self)
        let targetURLA = "https://www.xxx.com/A/page"
        let targetURLB = "https://www.xxx.com/A/B/page"
        let targetURLC = "https://www.xxx.com/A/B/C/page"
        let targetURLD = "https://www.xxx.com/A/C/page"
        let targetURLE = "https://www.xxx.com/B/C/page"
        
        // when
        let resultA = Router.shared.canRoute(to: targetURLA)
        let resultB = Router.shared.canRoute(to: targetURLB)
        let resultC = Router.shared.canRoute(to: targetURLC)
        let resultD = Router.shared.canRoute(to: targetURLD)
        let resultE = Router.shared.canRoute(to: targetURLE)
        
        // then
        XCTAssertTrue(resultA)
        XCTAssertTrue(resultB)
        XCTAssertTrue(resultC)
        XCTAssertTrue(resultD)
        XCTAssertFalse(resultE)
        
        // end
        Router.shared.unRegister(jumper: OptionalModuleJumper.self)
    }
    
    func testTreatHostAsPath() {
        // given
        Router.shared.register(jumper: RouteJumper.self, scheme: "scheme", option: [.treatHostAsPathComponent])
        let targetURL = "scheme://routeJumper/A"
        
        // when
        let result = Router.shared.canRoute(to: targetURL)
        
        // then
        XCTAssertTrue(result)
        
        // given
        Router.shared.register(jumper: RouteJumper.self, scheme: "schemeA", option: [])
        
        // when
        let targetURLA = "schemeA://routeJumper/A"
        
        // then
        let resultA = Router.shared.canRoute(to: targetURLA)
        XCTAssertFalse(resultA)
        
        // end
        Router.shared.unRegister(jumper: RouteJumper.self, scheme: "schemeA")
        Router.shared.unRegister(jumper: RouteJumper.self, scheme: "scheme")
    }
    
    func testInterceptorRejectAndPass() {
        // given
        Router.shared.register(jumper: OptionalModuleJumper.self, scheme: "reject")
        Router.shared.add(interceptor: WhiteListInterceptor(), for: "reject")
        
        let targetURLA = "reject://www.notWhiteList.com/A/page"
        let targetURLB = "reject://www.whitelist.com/A/page"
        
        // when
        let resultA = Router.shared.route(to: targetURLA)
        let resultB = Router.shared.route(to: targetURLB)
        
        // then
        XCTAssertEqual(Router.shared.searchRoutes(scheme: "reject").interceptors.count, 1)
        XCTAssertFalse(resultA)
        XCTAssertTrue(resultB)
        
        // end
        Router.shared.searchRoutes(scheme: "reject").removeAllInterceptor()
    }
    
    func testNoScheme() {
        // given
        let url = "there/is/no/scheme"
        
        // when
        let result = Router.shared.route(for: url)
        
        // then
        XCTAssertIdentical(result, Router.shared.defaultRoute)
    }
    
    func testMutableInterceptorReturnReject() {
        // given
        Router.shared.register(jumper: OptionalModuleJumper.self, scheme: "reject")
        Router.shared.add(interceptor: PassInterceptor(), for: "reject")
        Router.shared.add(interceptor: NotPassInterceptor(), for: "reject")
        
        let targetURLA = "reject://www.notPass.com/A/page"
        
        // when
        let resultA = Router.shared.route(to: targetURLA)
        
        // then
        XCTAssertFalse(resultA)
        
        // end
        Router.shared.register(jumper: OptionalModuleJumper.self, scheme: "reject")
        Router.shared.searchRoutes(scheme: "reject").removeAllInterceptor()
    }
    
    func testMutableInterceptorReturnPass() {
        // given
        Router.shared.register(jumper: OptionalModuleJumper.self, scheme: "pass")
        Router.shared.add(interceptor: PassInterceptor(), for: "pass")
        Router.shared.add(interceptor: PassInterceptor(), for: "pass")
        
        let targetURLA = "pass://www.notPass.com/A/page"
        
        // when
        let resultA = Router.shared.route(to: targetURLA)
        
        // then
        XCTAssertTrue(resultA)
        
        // end
        Router.shared.register(jumper: OptionalModuleJumper.self, scheme: "pass")
        Router.shared.searchRoutes(scheme: "pass").removeAllInterceptor()
    }
    
    func testAddDefinitionInOrderOfPriority() {
        // given
        let definition0 = Definition.init(jumper: RouteJumper.self, pattern: "definition0", priority: 0)
        let definition1 = Definition.init(jumper: RouteJumper.self, pattern: "definition1", priority: 1)
        
        // when
        Router.shared.defaultRoute.add(definition: definition0)
        Router.shared.defaultRoute.add(definition: definition1)
        
        // then
        XCTAssertEqual(Router.shared.defaultRoute.definitions[0] as! Definition<RouteJumper>, definition1)
        XCTAssertEqual(Router.shared.defaultRoute.definitions[1] as! Definition<RouteJumper>, definition0)
    }
    
    func testRoutesConfiguration() {
        // given
        let configuration: [RouteOption] = [.treatHostAsPathComponent]
        
        // when
        Router.shared.defaultRoute.config(options: configuration)
        
        // then
        XCTAssertEqual(configuration, Router.shared.defaultRoute.routeOption)
        
        // end
        Router.shared.defaultRoute.routeOption = []
    }
}
