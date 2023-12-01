//
//  Request.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/16.
//

import Foundation

public class Request {
    
    var url: String
    var pathComponents: [String] = []
    var parameters: [String: Any] = [:]
    
    init(url: String, additionalParameter: [String: Any], option: [RouteOption]) {
        self.url = url
        parse(url: url, additionalParameter: additionalParameter, option: option)
    }
    
    func parse(url: String, additionalParameter: [String: Any], option: [RouteOption]) {
        guard var urlcomponent = URLComponents.init(string: url) else { return }
        if option.contains(.treatHostAsPathComponent) {
            urlcomponent.path = (urlcomponent.host?.removingPercentEncoding ?? "") + urlcomponent.path
            urlcomponent.host = ""
        }
        // put main query into parameters
        parameters = urlcomponent.route_queryParameters().route_decodeParameter(option: option)
        // put fragment query into parameters
        if let fragment = urlcomponent.fragment,
           fragment.isEmpty == false,
           var fragmentComponent = URLComponents.init(string: fragment) {
            if fragmentComponent.query?.isEmpty == true {
                fragmentComponent.query = fragmentComponent.path
            }
            var fragmentContainQueryItems = false
            if let fragmentQueryItems = fragmentComponent.queryItems {
                fragmentContainQueryItems = true
                fragmentQueryItems.forEach { item in
                    parameters[item.name] = item.value
                }
            }

            if fragmentContainQueryItems == false || (fragmentContainQueryItems == true && fragmentComponent.query != fragmentComponent.path) {
                urlcomponent.path = "\(urlcomponent.path)#\(fragmentComponent.path)"
            }
        }
        pathComponents = urlcomponent.path.route_replacePlusWithSpaceIfNeed(using: option).route_trimmingSlashes()
    }
}
