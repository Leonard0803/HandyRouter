//
//  Jumper.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/14.
//

import Foundation

public protocol Jumper: RouterPage, CaseIterable, RawRepresentable<String> {
    static func jump(to page: Self, parameters: [ParameterKey: Any]) -> Bool
}
