//
//  String+Extension.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/16.
//

import Foundation

extension String {
    func route_replacePlusWithSpaceIfNeed(using option: [RouteOption]) -> String {
        if option.contains(.decodePlusSymbol) {
            return self.replacingOccurrences(of: "+", with: " ", options: [.literal], range: startIndex..<endIndex)
        } else {
            return self
        }
    }
    
    func route_trimmingSlashes() -> [String] {
        self.trimmingCharacters(in: ["/"]).components(separatedBy: "/")
    }
    
    func route_scanOptionalPaths() -> [SubPath] {
        let scanner = Scanner.init(string: self)
        if self.contains("(") == false {
            return []
        }
        var subPath: [SubPath] = []
        while !scanner.isAtEnd {
            let path = scanner.scanUpToString("(")
            if let dirtyPath = path, dirtyPath != "(" , dirtyPath != "/" {
                let paths = dirtyPath.split(separator: "/").compactMap { $0.trimmingCharacters(in: ["/"])}
                let subPaths = paths.map { path in
                    SubPath(isOptional: false, path: path)
                }
                subPath.append(contentsOf: subPaths)
            }
            let char = scanner.scanCharacter()
            if char == "(" {
                if let optionalPath = scanner.scanUpToString(")"), optionalPath.isEmpty == false {
                    let optionalPaths = optionalPath.components(separatedBy: ["/"]).map {
                        SubPath.init(isOptional: true, path: $0.trimmingCharacters(in: ["/"]))
                    }
                    subPath.append(contentsOf: optionalPaths)
                }
                _ = scanner.scanCharacter()
            }
        }
        return subPath.filter {
            $0.path.isEmpty == false
        }
    }
}
