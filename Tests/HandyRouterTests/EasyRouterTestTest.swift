//
//  HandyRouterTests.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/16.
//

import XCTest
import HandyRouter

final class HandyRouterTests: XCTestCase {
    
    let suite = Router.default

    func testCanRoute() throws {
        Router.default.register(jumper: ModuleJumper.self)
        let url1 = "https://www.HandyRouter.com/module/pageA"
        let canRouteUrl1 = suite.canRoute(to: url1)
        let url2 = "https://www.HandyRouter.com/module/pageB"
        let canRouteUrl2 = suite.canRoute(to: url2)
        let url3 = "https://www.HandyRouter.com/module/pageC#fragment"
        let canRouteUrl3 = suite.canRoute(to: url3)
        let url4 = "https://www.HandyRouter.com/module/pageD#fragment"
        let canRouteUrl4 = suite.canRoute(to: url4)
        let url5 = "https://www.HandyRouter.com/module/pageE"
        let canRouteUrl5 = suite.canRoute(to: url5)
        let url6 = "https://www.HandyRouter.com/otherModule/pageE"
        let canRouteUrl6 = suite.canRoute(to: url6)
        XCTAssertEqual(canRouteUrl1, true)
        XCTAssertEqual(canRouteUrl2, true)
        XCTAssertEqual(canRouteUrl3, true)
        XCTAssertEqual(canRouteUrl4, true)
        XCTAssertEqual(canRouteUrl5, true)
        XCTAssertEqual(canRouteUrl6, false)
    }
    
    func testRouteTo() throws {
        Router.default.register(jumper: ModuleJumper.self)
        let url1 = "https://www.HandyRouter.com/module/pageA"
        let canRouteUrl1 = suite.route(to: url1)
        let url2 = "https://www.HandyRouter.com/module/pageB"
        let canRouteUrl2 = suite.route(to: url2)
        let url3 = "https://www.HandyRouter.com/module/pageC#fragment"
        let canRouteUrl3 = suite.route(to: url3)
        let url4 = "https://www.HandyRouter.com/module/pageD#fragment"
        let canRouteUrl4 = suite.route(to: url4, parameters: [:])
        let url5 = "https://www.HandyRouter.com/module/pageE"
        let canRouteUrl5 = suite.route(to: url5, parameters: [:])
        let url6 = "https://www.HandyRouter.com/otherModule/pageE"
        let canRouteUrl6 = suite.route(to: url6, parameters: [:])
        XCTAssertEqual(canRouteUrl1, true)
        XCTAssertEqual(canRouteUrl2, true)
        XCTAssertEqual(canRouteUrl3, true)
        XCTAssertEqual(canRouteUrl4, false)
        XCTAssertEqual(canRouteUrl5, false)
        XCTAssertEqual(canRouteUrl6, false)
    }
}
