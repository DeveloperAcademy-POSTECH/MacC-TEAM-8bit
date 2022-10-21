//
//  CoreDataManager.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/21.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    // VideoInfo 구조체를 매개변수로 받아 VideoInformation NSManagedObject에 추가
    func createData(info: VideoInfo) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "VideoInformation", into: context)
        
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(info.gymName, forKey: "gymName")
        entity.setValue(info.gymVisitDate, forKey: "gymVisitDate")
        entity.setValue(info.videoUrl, forKey: "videoUrl")
        entity.setValue(info.problemLevel, forKey: "problemLevel")
        entity.setValue(info.isSucceeded, forKey: "isSucceeded")
        
        saveData()
    }
    
    // Core Data의 읽어 VideoInformation 클래스를 반환합니다.
    func readData() -> [VideoInformation] {
        var information: [VideoInformation] = []
        
        do {
            information = try context.fetch(VideoInformation.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        
        return information
    }
    
    // 추가한 데이터를 현재 context에 반영
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func filterVideoInformation(filterOption: FilterOption) -> [VideoInformation] {
        
        let originInformation = videoInformation
        
        switch filterOption {
        case .all:
            return originInformation
        case .favorite:
            return originInformation.filter({ $0.isFavorite })
        case .success:
            return originInformation.filter({ $0.isSucceeded })
        case .failure:
            return originInformation.filter({ !$0.isSucceeded })
        }
    }
    
}
