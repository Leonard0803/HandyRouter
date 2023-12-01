//
//  Resource.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/14.
//

import Foundation

public protocol Resource {
    var url: URL? { get }
}

extension URL: Resource {
    public var url: URL? {
        return self
    }
}

extension String: Resource {
    public var url: URL? {
        return URL.init(string: self)
    }
}
