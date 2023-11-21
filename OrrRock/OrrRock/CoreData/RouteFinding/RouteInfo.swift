//
//  RouteInfo.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/24.
//

import Foundation

struct RouteInfo {
    var imageLocalIdentifier: String
    var dataWrittenDate: Date
    var gymName: String
    var problemLevel: Int
    var isChallengeComplete: Bool
    var pages: [PageInfo]
}
