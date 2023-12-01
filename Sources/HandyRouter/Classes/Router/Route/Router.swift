//
//  Router.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/14.
//

import Foundation

public class Router {
    public static let defaultScheme = "__DefaultScheme__"
    public static let pagePlaceHolder = ":__PAGE__"
    
    public static let `default` = Router(shouldFallBack: true)
    
    public private(set) lazy var defaultRoute = createRoutes(for: Router.defaultScheme, option: [])
    
    private var routes: [String: Routes] = [:]
    
    private var shouldFallBack: Bool = true
    
    public init(shouldFallBack: Bool) {
        self.shouldFallBack = shouldFallBack
    }
    
    public func register<T: Jumper>(jumper: T.Type, scheme: String = defaultScheme, option: [RouteOption] = []) {
        let pattern = jumper.module.trimmingCharacters(in: ["/"])
        let definition = Definition<T>.init(jumper: jumper, pattern: pattern + "/\(Router.pagePlaceHolder)")
        definition.expandPattern().forEach { definition in
            let route = createRoutes(for: scheme, option: option)
            route.add(definition: definition)
        }
    }

    public func unRegister<T: Jumper>(jumper: T.Type, scheme: String = Router.defaultScheme) {
        let route = searchRoutes(for: scheme)
        let pattern = jumper.module.trimmingCharacters(in: ["/"])
        let definition = Definition<T>.init(jumper: jumper, pattern: pattern + "/\(Router.pagePlaceHolder)")
        definition.expandPattern().forEach { definition in
            route.remove(definition: definition)
        }
    }
    
    public func route(for resource: Resource) -> Routes {
        guard let scheme = resource.url?.scheme else {
            return defaultRoute
        }
        return routes[scheme, default: defaultRoute]
    }
    
    public func createRoutes(for scheme: String, option: [RouteOption] = []) -> Routes {
        if let route = routes[scheme] {
            return route
        } else {
            let route = Routes(scheme: scheme, routeOption: option)
            routes[scheme] = route
            return route
        }
    }
    
    public func searchRoutes(for scheme: String) -> Routes {
        if let route = routes[scheme] {
            return route
        } else {
            return defaultRoute
        }
    }
    
    @discardableResult
    public func route(to resource: Resource, parameters: [String: Any] = [:]) -> Bool{
        let route = route(for: resource)
        let didRoute = route.route(to: resource, parameters: parameters, execute: true)
        if didRoute == false && shouldFallBack && route !== defaultRoute {
            return defaultRoute.route(to: resource, parameters: parameters, execute: true)
        } else {
            return didRoute
        }
    }
    
    public func canRoute(to resource: Resource) -> Bool {
        let route = route(for: resource)
        let didRoute = route.route(to: resource, parameters: [:], execute: false)
        if didRoute == false && shouldFallBack && route !== defaultRoute {
            return defaultRoute.route(to: resource, parameters: [:], execute: false)
        } else {
            return didRoute
        }
    }
}
