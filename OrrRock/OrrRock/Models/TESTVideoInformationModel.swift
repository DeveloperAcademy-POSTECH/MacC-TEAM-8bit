//
//  TestVideoInformationModel.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/20.
//

import Foundation

class TESTVideoInformationModel {
    
    let id: UUID = UUID()
    let gymName: String
    let gymVisitDate: Date
    let thumbnail: String
    let isSuccessed: Bool
    
    init(gymName: String, gymVisitDate: Date, thumbnail: String, isSuccessed: Bool) {
        self.gymName = gymName
        self.gymVisitDate = gymVisitDate
        self.thumbnail = thumbnail
        self.isSuccessed = isSuccessed
    }
}

extension TESTVideoInformationModel {
    static let example: [TESTVideoInformationModel] = [
        TESTVideoInformationModel(gymName: "아띠 클라이밍", gymVisitDate: Date(), thumbnail: "person", isSuccessed: false),
        TESTVideoInformationModel(gymName: "아띠 클라이밍", gymVisitDate: Date(), thumbnail: "car", isSuccessed: false),
        TESTVideoInformationModel(gymName: "아띠 클라이밍", gymVisitDate: Date(), thumbnail: "gear", isSuccessed: true),
        TESTVideoInformationModel(gymName: "아띠 클라이밍", gymVisitDate: Date(), thumbnail: "pencil", isSuccessed: false),
    ]
    static let example2: [TESTVideoInformationModel] = [
        TESTVideoInformationModel(gymName: "스파이더 클라이밍", gymVisitDate: Date(), thumbnail: "pencil.tip", isSuccessed: true),
        TESTVideoInformationModel(gymName: "스파이더 클라이밍", gymVisitDate: Date(), thumbnail: "trash.fill", isSuccessed: false),
        TESTVideoInformationModel(gymName: "스파이더 클라이밍", gymVisitDate: Date(), thumbnail: "paperplane.circle", isSuccessed: true),
        TESTVideoInformationModel(gymName: "스파이더 클라이밍", gymVisitDate: Date(), thumbnail: "externaldrive.badge.plus", isSuccessed: true),
    ]
}
