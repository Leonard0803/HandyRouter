//
//  ParameterKey.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/17.
//

import Foundation

public struct ParameterKey: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    
    var key: String = ""
    
    public init(stringLiteral value: StringLiteralType) {
        self.key = value
    }
    public var description: String {
        return key
    }
}

extension ParameterKey {
    static let page: ParameterKey = "__PAGE__"
    static let url: ParameterKey = "__URL__"
}

public extension Dictionary where Key == ParameterKey {
    
    var toUrl: String {
        guard let value = self[.url] as? String else {
            return ""
        }
        return value
    }
    
    var toPage: String {
        guard let value = self[.page] as? String else {
            return ""
        }
        return value
    }
}
