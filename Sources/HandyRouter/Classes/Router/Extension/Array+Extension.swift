//
//  Array+Extension.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/27.
//

import Foundation

extension Array where Element == SubPath {
    func recurringExhaustive() -> [[SubPath]] {
        guard self.isEmpty == false else { return [[]] }
        let currentExhaustivePaths = (Array(self[0..<count - 1])).recurringExhaustive()
        var tempPaths = currentExhaustivePaths
        currentExhaustivePaths.forEach { ceps in
            var tempCeps = ceps
            if let lastPath = self.last {
                tempCeps.append(lastPath)
            }
            tempPaths.append(tempCeps)
        }
        return tempPaths
    }
}
