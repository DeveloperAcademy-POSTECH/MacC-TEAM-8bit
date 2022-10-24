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
    
    func sortRepository(filterOption: FilterOption, sortOption: SortOption, orderOption: OrderOption) {
        repository.finalSortVideoInformation(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
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
}
