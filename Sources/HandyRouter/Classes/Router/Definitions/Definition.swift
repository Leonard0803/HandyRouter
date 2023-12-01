//
//  Definition.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/14.
//

import Foundation

extension Router {
    static let pattern = "__PATTERN__"
    static let url = "__URL__"
}

public class Definition<T: Jumper> {
    
    public var pattern: String = ""
    public var priority: Int = 0
    public var pathComponents: [String]
    var jumper: T.Type

    init(jumper: T.Type,
         pattern: String,
         priority: Int = 0) {
        self.jumper = jumper
        self.priority = priority
        self.pattern = pattern
        self.pathComponents = pattern.trimmingCharacters(in: ["/"]).components(separatedBy: "/")
    }
    
    func expandPattern() -> [Definition] {
        let optionPaths = self.pattern.route_scanOptionalPaths()
        if optionPaths.isEmpty {
            return [self]
        } else {
            let obligatoryPaths = optionPaths.filter {
                $0.isOptional == false
            }
            let obligatorySet = Set.init(obligatoryPaths)
            return optionPaths.recurringExhaustive().filter {
                let optionSets = Set.init($0)
                return obligatorySet.isSubset(of: optionSets)
            }.map { subPaths in
                let pattern = subPaths.map { $0.path }.joined(separator: "/")
                return Definition.init(jumper: self.jumper, pattern: pattern)
            }
        }
    }
    
    func pageInfo(from request: Request) -> [String: Any]? {
        var parameters: [String: String] = [:]
        
        let tempPathComponents = pathComponents
        var requestPathComponents = request.pathComponents
        var pageValue = requestPathComponents.last
        if requestPathComponents.count > 1 {
            requestPathComponents = Array(requestPathComponents.dropLast())
        } else {
            pageValue = ""
        }
        
        guard let pageKey = tempPathComponents.last,
              let pageValue = pageValue,
              tempPathComponents.dropLast().isEmpty == false,
              requestPathComponents.isEmpty == false else {
            return nil
        }

        let isMatch = Validator.matchWildcardPath(urls: Array(requestPathComponents), availablePath: Array(tempPathComponents.dropLast()))
        if isMatch && pageKey.hasPrefix(":") {
            let pageKey = String(pageKey.dropFirst())
            parameters[pageKey] = pageValue.removingPercentEncoding
            return parameters
        }
        return nil
    }
}

extension Definition: Hashable {
    public static func == (lhs: Definition, rhs: Definition) -> Bool {
        return lhs.pattern == rhs.pattern &&
        lhs.priority == rhs.priority &&
        lhs.pathComponents == rhs.pathComponents
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pattern)
        hasher.combine(priority)
        hasher.combine(pathComponents)
    }
}

extension Definition: ModuleRoutingResolver {
    
    public func response(for request: Request) -> Response {
        if pathComponents.contains(where: { $0 == "*"}) == false &&
            request.pathComponents.count > 1 &&
            pathComponents.count != request.pathComponents.count {
            return .invalid
        }
        var parameter: [String: Any] = [:]
        guard let pageInfo = pageInfo(from: request) else {
            return .invalid
        }
        parameter.merge(request.parameters) { key1, key2 in key1 }
        parameter.merge(pageInfo) { key1, key2 in key1 }
        parameter[Router.url] = request.url
        parameter[Router.pattern] = self.pattern
        return Response.init(match: true, parameters: parameter)
    }
    
    public func invokeJump(parameters: [String : Any]) -> Bool {
        
        let parameterKeyDict = parameters.reduce(into: [:]) { (partialResult, tuple: (key: String, value: Any)) in
            partialResult[ParameterKey(stringLiteral: tuple.key)] = tuple.value
        }
        let pageName = parameterKeyDict.toPage
        
        guard let page = T.init(rawValue: pageName) else {
            return false
        }
        let match = T.allCases.contains { definePage in
            definePage == page
        }
        if match == false { return false }
        return jumper.jump(to: page, parameters: parameterKeyDict)
    }
}
