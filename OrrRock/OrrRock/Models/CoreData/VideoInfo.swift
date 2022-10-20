//
//  VideoInfo.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/20.
//

import Foundation

struct VideoInfo {
    var gymName: String
    var gymVisitDate: Date
    var videoUrl: String
    var problemLevel: Int
    var isSucceeded: Bool
    var feedback: String
    var isFavorite: Bool
    
    // 기본 Initializer: isFavorite, feedback은 자동적으로 할당
    init(gymName: String, gymVisitDate: Date, videoUrl: String, problemLevel: Int, isSucceeded: Bool) {
        self.gymName = gymName
        self.gymVisitDate = gymVisitDate
        self.videoUrl = videoUrl
        self.problemLevel = problemLevel
        self.isSucceeded = isSucceeded
        self.isFavorite = false
        self.feedback = ""
    }
}
