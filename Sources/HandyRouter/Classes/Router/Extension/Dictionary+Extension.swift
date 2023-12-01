//
//  Dictionary+Extension.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/17.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func route_decodeParameter(option: [RouteOption]) -> Dictionary {
        guard option.contains(.decodePlusSymbol) else { return self }
        var newDict: [String: Any] = [:]
        self.keys.forEach { key in
            let value = self[key]
            if let arrayValue = value as? Array<String> {
                newDict[key] = arrayValue.map {
                    $0.route_replacePlusWithSpaceIfNeed(using: option)
                }
            } else if let stringValue = value as? String {
                newDict[key] = stringValue.route_replacePlusWithSpaceIfNeed(using: option)
            }
        }
        return newDict
    }
}
