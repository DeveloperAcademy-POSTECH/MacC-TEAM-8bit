//
//  RouteInfo.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
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

extension RouteInfo {
    static let dummyData = RouteInfo(
        imageLocalIdentifier: "08FFDC53-E916-4F9A-AFCD-108732A4D6A2/L0/001",
        dataWrittenDate: Date(),
        gymName: "아띠띠뜨띠뜨띠띠띠뜨띠",
        problemLevel: 2,
        isChallengeComplete: true,
        pages: [
            PageInfo(rowOrder: 0, points: nil),
            PageInfo(rowOrder: 1, points: nil),
            PageInfo(rowOrder: 2, points: nil),
            PageInfo(rowOrder: 3, points: nil),
            PageInfo(rowOrder: 4, points: nil),
            PageInfo(rowOrder: 5, points: nil)
        ])
}
