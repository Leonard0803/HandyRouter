//
//  RouteInterceptor.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/17.
//

import Foundation

public enum RouteInterceptorState {
    case reject, pass
}

public protocol RouteInterceptor {
    func perform(parameters: [String : Any]) -> RouteInterceptorState
}
