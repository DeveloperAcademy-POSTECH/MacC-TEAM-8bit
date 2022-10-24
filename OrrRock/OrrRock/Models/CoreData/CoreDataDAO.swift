//
//  CoreDataManager.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/21.
//

import UIKit
import CoreData

class CoreDataDAO {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    init() { }
    
    // VideoInfo 구조체를 매개변수로 받아 VideoInformation NSManagedObject에 추가
    func createData(info: VideoInfo) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "VideoInformation", into: context)
        
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(info.gymName, forKey: "gymName")
        entity.setValue(info.gymVisitDate, forKey: "gymVisitDate")
        entity.setValue(info.videoLocalIdentifier, forKey: "videoUrl")
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
    
    func updateDateAndGymData(videoInformation: VideoInformation, gymVisitDate: Date, gymName: String) {

        guard let id = videoInformation.id else { return }
        let request = VideoInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    do {
                        let info = try context.fetch(request)
                            if let tempInfo = info.first {
                                tempInfo.setValue(gymVisitDate, forKey: "gymVisitDate")
                                tempInfo.setValue(gymName, forKey: "gymName")
                            }
                        } catch {
                        print("업데이트 실패")
                    }
            saveData()
    }
    
    // MARK: EditCase TWO 2 - 코드 반복 O
    func updateLevelAndPF(videoInformation: VideoInformation, problemLevel: Int, isSucceeded: Bool) {

        guard let id = videoInformation.id else { return }
        let request = VideoInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    do {
                        let info = try context.fetch(request)
                            if let tempInfo = info.first {
                                tempInfo.setValue(problemLevel, forKey: "problemLevel")
                                tempInfo.setValue(isSucceeded, forKey: "isSucceeded")
                            }
                        } catch {
                        print("업데이트 실패")
                    }
            saveData()
    }
    
    func updateFavorite(videoInformation: VideoInformation, isFavorite: Bool) {
        
        guard let id = videoInformation.id else { return }
        let request = VideoInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    do {
                        let info = try context.fetch(request)
                            if let tempInfo = info.first {
                                tempInfo.setValue(isFavorite, forKey: "isFavorite")
                            }
                        } catch {
                        print("업데이트 실패")
                    }
            saveData()
    }
    
    func updateFeedback(videoInformation: VideoInformation, feedback: String) {

        guard let id = videoInformation.id else { return }
        let request = VideoInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    do {
                        let info = try context.fetch(request)
                            if let tempInfo = info.first {
                                tempInfo.setValue(feedback, forKey: "feedback")
                            }
                        } catch {
                        print("업데이트 실패")
                    }
            saveData()
    }
    
    func deleteData(videoInformation: VideoInformation) {
        
        guard let id = videoInformation.id else { return }
        let request = VideoInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
                if let tempInfo = info.first {
                    context.delete(tempInfo)
                }
            } catch {
            print("업데이트 실패")
        }
        saveData()
    }
    
    func deleteAllData() {
        let objects = readData()
        
        if objects.count > 0 {
            for object in objects {
                context.delete(object)
            }
            print("DELETE ALL DATA")
            saveData()
        } else {
            print()
        }
    }
    
    // 추가한 데이터를 현재 context에 반영
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
