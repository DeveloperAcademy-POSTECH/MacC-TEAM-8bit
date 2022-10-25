//
//  DummyVideoModel.swift
//  OrrRock
//
//  Created by Yeni Hwang, 이성노 on 2022/10/25.
//

import Foundation

// 코어데이터 연결 전 사용할 임시 모델입니다
//struct VideoInfo {
//    var id: Int
//    var videoURL: String
//    var problemLevel: Int
//    var isSuccess: Bool
//}

class VideoManager {

    static let shared = VideoManager()

    let dummyVideoList: [VideoInfo] = [
        VideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        VideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        VideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        VideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        ),
        VideoInfo(
            gymName: "아띠",
            gymVisitDate: Date(),
            videoLocalIdentifier: "identifier",
            problemLevel: 2,
            isSucceeded: true
        )
    ]

    func fetchVideo() -> [VideoInfo] {
        return self.dummyVideoList
    }
}
