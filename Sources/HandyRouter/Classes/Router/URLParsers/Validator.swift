//
//  Validator.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/23.
//

import Foundation

struct Validator {
    @discardableResult
    static func matchWildcardPath(urls: [String], availablePath: [String]) -> Bool {
        var matchedPath: [String] = []
        var urlPaths = urls
        var wildcardMatchModeOn = false
        var isAllMatch = true
        for apath in availablePath {
            if apath == "*" {
                wildcardMatchModeOn = true
                continue
            }
            if wildcardMatchModeOn {
                guard let index = urlPaths.firstIndex(of: apath) else {
                    isAllMatch = false
                    break
                }
                let match = urlPaths[index]
                matchedPath.append(match)
                let sliceStartIndex = urlPaths.index(index, offsetBy: 1)
                let sliceEndIndex = urlPaths.endIndex
                urlPaths = Array(urlPaths[sliceStartIndex..<sliceEndIndex])
                wildcardMatchModeOn = false
            } else {
                guard let first = urlPaths.first, first == apath else {
                    isAllMatch = false
                    break
                }
                matchedPath.append(apath)
                urlPaths = Array(urlPaths.dropFirst())
            }
        }
        return isAllMatch
    }
}
