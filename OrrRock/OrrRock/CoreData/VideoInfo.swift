//
//  VideoInfo.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/20.
//

import Foundation

struct VideoInfo {
    var gymName: String
    var gymVisitDate: Date
    var videoLocalIdentifier: String
    var problemLevel: Int
    var isSucceeded: Bool
    var isDeleted: Bool
    
    // 초기값 설정
    init(gymName: String, gymVisitDate: Date, videoLocalIdentifier: String, problemLevel: Int, isSucceeded: Bool, isDeleted: Bool = false) {
        self.gymName = gymName
        self.gymVisitDate = gymVisitDate
        self.videoLocalIdentifier = videoLocalIdentifier
        self.problemLevel = problemLevel
        self.isSucceeded = isSucceeded
        self.isDeleted = isDeleted
    }
}
