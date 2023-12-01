//
//  RouterPage.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/14.
//

import Foundation

public protocol RouterPage {
    static var module: String { get }
    var page: String { get }
}

public extension RouterPage where Self: RawRepresentable, RawValue == String {
    var page: String {
        self.rawValue
    }
}
