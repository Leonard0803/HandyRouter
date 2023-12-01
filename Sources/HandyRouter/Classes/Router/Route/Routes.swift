//
//  Routes.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/14.
//

import Foundation

public struct RouteOption: OptionSet {
    
    public var rawValue: Int
    public static var decodePlusSymbol = RouteOption.init(rawValue: 1 << 0)
    public static var treatHostAsPathComponent = RouteOption.init(rawValue: 1 << 1)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}

public class Routes {
    
    public typealias UnmatchHandler = (Routes, Resource, [String: Any]) -> Void
    
    public var unmatchHandler: UnmatchHandler = { _, _, _ in }
    
    public private(set) var definitions: [ModuleRoutingResolver] = []
    
    public var scheme: String
    
    public var interceptors: [RouteInterceptor] = []
    
    public var routeOption: [RouteOption]
    
    init(scheme: String, routeOption: [RouteOption]) {
        self.scheme = scheme
        self.routeOption = routeOption
    }
    
    public func config(options: [RouteOption]) {
        self.routeOption = options
    }
    
    func add<T>(definition: Definition<T>) {
        if definitions.isEmpty || definition.priority == 0 {
            definitions.append(definition)
        } else {
            let index = definitions.firstIndex {
                $0.priority < definition.priority
            }
            guard let index = index else {
                definitions.append(definition)
                return
            }
            definitions.insert(definition, at: index)
        }
    }
    
    func remove<T>(definition: Definition<T>) {
        definitions.removeAll {
            if let tempDefinition = $0 as? Definition<T> {
                return tempDefinition == definition
            }
            return false
        }
    }
    
    func add(interceptor: RouteInterceptor) {
        interceptors.append(interceptor)
    }
    
    func route(to resource: Resource, parameters: [String: Any], execute: Bool) -> Bool {
        var canRoute = false
        guard let url = resource.url else {
            unmatchHandler(self, resource, parameters)
            return false
        }
        let request = Request.init(url: url.absoluteString, additionalParameter: parameters, option: routeOption)
        for definition in definitions {
            let response = definition.response(for: request)
            if response.match {
                if execute == false {
                    return true
                }
                let runner = InterceptorRunner.init(interceptors: interceptors)
                let state = runner.perform(parameters: response.parameters)
                switch state {
                case .pass:
                    canRoute = true
                    return definition.invokeJump(parameters: response.parameters)
                case .reject:
                    canRoute = false
                }
                break
            }
        }
        if canRoute == false {
            unmatchHandler(self, resource, request.parameters)
        }
        return canRoute
    }
}

extension Routes {
    
    class MultiplexInterceptorRunner {
        
        static func perform(parameters: [String: Any], interceptors: [RouteInterceptor]) -> RouteInterceptorState {
            if let interceptor = interceptors.first {
                let state = interceptor.perform(parameters: parameters)
                if state == .pass {
                    return perform(parameters: parameters, interceptors: Array(interceptors.dropFirst()))
                } else {
                    return .reject
                }
            } else {
                return .pass
            }
        }
    }
    
    class InterceptorRunner {
        
        var interceptors: [RouteInterceptor] = []
        
        init(interceptors: [RouteInterceptor]) {
            self.interceptors = interceptors
        }
        
        func perform(parameters: [String: Any]) -> RouteInterceptorState {
            if interceptors.isEmpty {
                return .pass
            }
            if interceptors.count == 1 {
                return interceptors[0].perform(parameters: parameters)
            } else {
                return MultiplexInterceptorRunner.perform(parameters: parameters, interceptors: interceptors)
            }
        }
    }
}
