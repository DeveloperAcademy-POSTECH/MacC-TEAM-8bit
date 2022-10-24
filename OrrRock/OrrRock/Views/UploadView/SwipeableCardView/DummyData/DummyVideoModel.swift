//
//  DummyVideoModel.swift
//  OrrRock
//
//  Created by Yeni Hwang on 2022/10/25.
//

import Foundation

// 코어데이터 연결 전 사용할 임시 모델입니다
struct DummyVideo {
    var id: Int
    var videoURL: String
    var problemLevel: Int
    var isSucceeded: Bool
}

class VideoManager {
    
    static let shared = VideoManager()
    
    let dummyVideoList: [DummyVideo] = [
        DummyVideo(id: 100, videoURL: "ianIsComming", problemLevel: 0, isSucceeded: false),
        DummyVideo(id: 101, videoURL: "ianIsComming", problemLevel: 0, isSucceeded: false),
        DummyVideo(id: 102, videoURL: "ianIsComming", problemLevel: 0, isSucceeded: false),
        DummyVideo(id: 103, videoURL: "ianIsComming", problemLevel: 0, isSucceeded: false),
        DummyVideo(id: 104, videoURL: "ianIsComming", problemLevel: 0, isSucceeded: false)
    ]
    
    func fetchVideo() -> [DummyVideo] {
        return self.dummyVideoList
    }
}
