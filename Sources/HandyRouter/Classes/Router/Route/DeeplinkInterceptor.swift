//
//  DeeplinkInterceptor.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/17.
//

import Foundation

struct DeeplinkInterceptor: RouteInterceptor {
    
    func perform(parameters: [String : Any]) -> RouteInterceptorState {
        return .pass
    }
}

struct WhiteListInterceptor: RouteInterceptor {
    
    var whiteList = [""]
    
    func perform(parameters: [String : Any]) -> RouteInterceptorState {
        if let url = parameters["url"] as? String, whiteList.contains(url) {
            return .pass
        }
        return .reject
    }
}
