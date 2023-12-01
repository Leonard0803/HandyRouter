//
//  URLComponent+Extension.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/17.
//

import Foundation

extension URLComponents {
    func route_queryParameters() -> [String: Any] {
        var parameters: [String: Any] = [:]
        self.queryItems?.forEach { item in
            guard let newValue = item.value else { return }
            if let value = parameters[item.name] {
                if var arrayValue = value as? Array<Any> {
                    arrayValue.append(newValue)
                    parameters[item.name] = arrayValue
                } else {
                    parameters[item.name] = [value, newValue]
                }
            } else {
                parameters[item.name] = newValue
            }
        }
        return parameters
    }
}
