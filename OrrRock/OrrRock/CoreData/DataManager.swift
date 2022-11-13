//
//  DataManager.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/25.
//

import Foundation

final class DataManager {
    
    static var shared = DataManager()
    
    var repository: DataRepository
    private var coreDataManager: CoreDataDAO
    
    init() {
        repository = DataRepository()
        coreDataManager = CoreDataDAO()
        updateRepository()
    }
    
    // CoreData로부터 읽은 데이터를 정렬 기준에 맞게 2차원 배열로 변경
    func sortRepository(filterOption: FilterOption, sortOption: SortOption, orderOption: OrderOption) -> [[VideoInformation]] {
        return repository.finalSortVideoInformation(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
    }
    
    // CoreData 정보를 DataRepository의 rawVideoInformation에 할당
    func updateRepository() {
        repository.rawVideoInformation = coreDataManager.readData()
    }
    
    // 단일 VideoInformation 데이터를 추가
    func createMultipleData(infoList: [VideoInfo]) {
        for info in infoList {
            createData(info: info)
        }
    }
    
    // 복수 VideoInformation 데이터를 추가
    func createData(info: VideoInfo) {
        let entity = coreDataManager.createData(info: info)
        repository.createData(info: entity as! VideoInformation)
    }
    
    // 암장 방문 날짜 및 이름 변경과 관련된 메소드
    func updateDateAndGymData(videoInformation: VideoInformation, gymVisitDate: Date, gymName: String) {
        coreDataManager.updateDateAndGymData(videoInformation: videoInformation, gymVisitDate: gymVisitDate, gymName: gymName)
        repository.updateDateAndGymData(videoInformation: videoInformation, gymVisitDate: gymVisitDate, gymName: gymName)
    }
    
    // 문제 난이도 및 성패 변경과 관련된 메소드
    func updateLevelAndPF(videoInformation: VideoInformation, problemLevel: Int, isSucceeded: Bool) {
        coreDataManager.updateLevelAndPF(videoInformation: videoInformation, problemLevel: problemLevel, isSucceeded: isSucceeded)
        repository.updateLevelAndPF(videoInformation: videoInformation, problemLevel: problemLevel, isSucceeded: isSucceeded)
    }
    
    // 문제 즐겨찾기 여부 변경과 관련된 메소드
    func updateFavorite(videoInformation: VideoInformation, isFavorite: Bool) {
        coreDataManager.updateFavorite(videoInformation: videoInformation, isFavorite: isFavorite)
        repository.updateFavorite(videoInformation: videoInformation, isFavorite: isFavorite)
    }
    
    // 문제 피드백 수정과 관련된 메소드
    func updateFeedback(videoInformation: VideoInformation, feedback: String) {
        coreDataManager.updateFeedback(videoInformation: videoInformation, feedback: feedback)
        repository.updateFeedback(videoInformation: videoInformation, feedback: feedback)
    }
    
    // 복수 데이터 삭제를 위한 메소드
    func deleteMultipleData(videoInformationList: [VideoInformation]) {
        for videoInformation in videoInformationList {
            deleteData(videoInformation: videoInformation)
        }
    }
    
    // 단일 데이터 삭제를 위한 메소드
    func deleteData(videoInformation: VideoInformation) {
        coreDataManager.deleteData(videoInformation: videoInformation)
        repository.deleteData(videoInformation: videoInformation)
    }
    
    // 전체 데이터 삭제를 위한 메소드
    func deleteAllData() {
        coreDataManager.deleteAllData()
        repository.deleteAllData()
    }
    
    // MARK: Data Printing을 위한 메소드로 Print문을 따로 삭제하지 않았습니다.
    func printRawData(standard: SortOption) {
        print(repository.rawVideoInformation.count)
        print("-----RAW-----")
        for info in repository.rawVideoInformation {
            printData(info: info, primarySortOption: standard)
        }
        print("------------")
        print("================================")
    }
    
    // MARK: Data Printing을 위한 메소드로 Print문을 따로 삭제하지 않았습니다.
    func printData(info: VideoInformation, primarySortOption: SortOption) {
        
        if primarySortOption == .gymName {
            print("\(info.gymName) | \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.videoLocalIdentifier) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        } else {
            print("| \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.gymName) | \(info.videoLocalIdentifier) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        }
    }
    
    func printDataList(info: [VideoInformation], primarySortOption: SortOption) {
        for information in repository.rawVideoInformation {
            printData(info: information,primarySortOption: primarySortOption)
        }
    }
}
