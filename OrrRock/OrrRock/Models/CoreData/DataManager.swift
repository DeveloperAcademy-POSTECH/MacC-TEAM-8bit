//
//  DataManager.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/25.
//

import Foundation

final class DataManager {
    
    static var shared = DataManager()
    
    private var repository: DataRepository!
    private var coreDataManager: CoreDataDAO!
    
    init() {
        repository = DataRepository()
        coreDataManager = CoreDataDAO()
    }
    
    func sortRepository(filterOption: FilterOption, sortOption: SortOption, orderOption: OrderOption) -> [[VideoInformation]] {
        return repository.finalSortVideoInformation(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
    }
    
    func updateRepository() {
        repository.rawVideoInformation = coreDataManager.readData()
    }
    
    func createData(info: VideoInfo) {
        coreDataManager.createData(info: info)
        repository.createData(info: info)
    }
    
    func updateDateAndGymData(videoInformation: VideoInformation, gymVisitDate: Date, gymName: String) {
        coreDataManager.updateDateAndGymData(videoInformation: videoInformation, gymVisitDate: gymVisitDate, gymName: gymName)
        repository.updateDateAndGymData(videoInformation: videoInformation, gymVisitDate: gymVisitDate, gymName: gymName)
    }
    
    func updateLevelAndPF(videoInformation: VideoInformation, problemLevel: Int, isSucceeded: Bool) {
        coreDataManager.updateLevelAndPF(videoInformation: videoInformation, problemLevel: problemLevel, isSucceeded: isSucceeded)
        repository.updateLevelAndPF(videoInformation: videoInformation, problemLevel: problemLevel, isSucceeded: isSucceeded)
    }
    
    func updateFavorite(videoInformation: VideoInformation, isFavorite: Bool) {
        coreDataManager.updateFavorite(videoInformation: videoInformation, isFavorite: isFavorite)
        repository.updateFavorite(videoInformation: videoInformation, isFavorite: isFavorite)
    }
    
    func updateFeedback(videoInformation: VideoInformation, feedback: String) {
        coreDataManager.updateFeedback(videoInformation: videoInformation, feedback: feedback)
        repository.updateFeedback(videoInformation: videoInformation, feedback: feedback)
    }
    
    func deleteData(videoInformation: VideoInformation) {
        coreDataManager.deleteData(videoInformation: videoInformation)
        repository.deleteData(videoInformation: videoInformation)
    }
    
    func deleteAllData() {
        coreDataManager.deleteAllData()
        repository.deleteAllData()
    }
    
    // 테스트용 Print문 : 추후 삭제될 예정
    func printRawData(standard: SortOption) {
        print(repository.rawVideoInformation.count)
        print("-----RAW-----")
        for info in repository.rawVideoInformation {
            printData(info: info, primarySortOption: standard)
        }
        print("------------")
        print("================================")
    }
    
    func printData(info: VideoInformation, primarySortOption: SortOption) {
        
        if primarySortOption == .gymName {
            print("\(info.gymName) | \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.videoUrl) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        } else {
            print("| \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.gymName) | \(info.videoUrl) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        }
    }
    
    func printDataList(info: [VideoInformation], primarySortOption: SortOption) {
        for information in repository.rawVideoInformation {
            printData(info: information,primarySortOption: primarySortOption)
        }
    }

}
