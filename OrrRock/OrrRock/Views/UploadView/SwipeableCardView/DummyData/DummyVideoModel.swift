//
//  DummyVideoModel.swift
//  OrrRock
//
//  Created by Yeni Hwang, 이성노 on 2022/10/25.
//

import Foundation

// 코어데이터 연결 전 사용할 임시 모델입니다
struct DummyVideoInfo {
    var gymName: String
    var gymVisitDate: Date
    var videoLocalIdentifier: String
    var problemLevel: Int
    var isSucceeded: Bool
}

class VideoManager {

    static let shared = VideoManager()

    let dummyVideoList: [DummyVideoInfo] = [
        DummyVideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        DummyVideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        DummyVideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        DummyVideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        DummyVideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        )
    ]

    func fetchVideo() -> [DummyVideoInfo] {
        return self.dummyVideoList
    }
}
