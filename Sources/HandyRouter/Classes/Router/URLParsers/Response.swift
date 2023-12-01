//
//  Response.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/16.
//

import Foundation

public class Response {
    
    var match: Bool = false
    var parameters: [String: Any]
    
    init(match: Bool, parameters: [String : Any]) {
        self.match = match
        self.parameters = parameters
    }
    
    static var invalid: Response {
        get {
            Response.init(match: false, parameters: [:])
        }
    }
}

extension Response: Equatable {
    
    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.match == rhs.match &&
        lhs.parameters.keys.sorted() == rhs.parameters.keys.sorted()
    }
}
