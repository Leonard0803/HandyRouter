//
//  HandyRouterTests.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/16.
//

import XCTest
import HandyRouter

final class HandyRouterTests: XCTestCase {
    
    let suite = Router.shared

    func testCanRoute() throws {
        // given
        Router.shared.register(jumper: ModuleJumper.self)
        let url1 = "https://www.HandyRouter.com/module/pageA"
        let url2 = "https://www.HandyRouter.com/module/pageB"
        let url3 = "https://www.HandyRouter.com/module/pageC#fragment"
        let url4 = "https://www.HandyRouter.com/module/pageD#fragment"
        let url5 = "https://www.HandyRouter.com/module/pageE"
        let url6 = "https://www.HandyRouter.com/otherModule/pageE"
        
        // when
        let canRouteUrl1 = suite.canRoute(to: url1)
        let canRouteUrl2 = suite.canRoute(to: url2)
        let canRouteUrl3 = suite.canRoute(to: url3)
        let canRouteUrl4 = suite.canRoute(to: url4)
        let canRouteUrl5 = suite.canRoute(to: url5)
        let canRouteUrl6 = suite.canRoute(to: url6)
        
        // then
        XCTAssertEqual(canRouteUrl1, true)
        XCTAssertEqual(canRouteUrl2, true)
        XCTAssertEqual(canRouteUrl3, true)
        XCTAssertEqual(canRouteUrl4, true)
        XCTAssertEqual(canRouteUrl5, true)
        XCTAssertEqual(canRouteUrl6, false)
        
        // end
        Router.shared.unRegister(jumper: ModuleJumper.self)
    }
    
    func testRouteTo() throws {
        // given
        Router.shared.register(jumper: ModuleJumper.self)
        let url1 = "https://www.HandyRouter.com/module/pageA"
        let url2 = "https://www.HandyRouter.com/module/pageB"
        let url3 = "https://www.HandyRouter.com/module/pageC#fragment"
        let url4 = "https://www.HandyRouter.com/module/pageD#fragment"
        let url5 = "https://www.HandyRouter.com/module/pageE"
        let url6 = "https://www.HandyRouter.com/otherModule/pageE"
        
        // when
        let canRouteUrl1 = suite.route(to: url1)
        let canRouteUrl2 = suite.route(to: url2)
        let canRouteUrl3 = suite.route(to: url3)
        let canRouteUrl4 = suite.route(to: url4, parameters: [:])
        let canRouteUrl5 = suite.route(to: url5, parameters: [:])
        let canRouteUrl6 = suite.route(to: url6, parameters: [:])
        
        // then
        XCTAssertEqual(canRouteUrl1, true)
        XCTAssertEqual(canRouteUrl2, true)
        XCTAssertEqual(canRouteUrl3, true)
        XCTAssertEqual(canRouteUrl4, false)
        XCTAssertEqual(canRouteUrl5, false)
        XCTAssertEqual(canRouteUrl6, false)
        
        // end
        Router.shared.unRegister(jumper: ModuleJumper.self)
    }
}
