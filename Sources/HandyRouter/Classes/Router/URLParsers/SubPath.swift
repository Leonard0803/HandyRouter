//
//  SubPath.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/22.
//

import Foundation

struct SubPath: CustomStringConvertible {
    
    var isOptional: Bool
    var path: String
    
    init(isOptional: Bool, path: String) {
        self.isOptional = isOptional
        self.path = path
    }
    
    var description: String {
        return "path: \(path), optioanl: \(isOptional)"
    }
}

extension SubPath: Hashable, Equatable {}
