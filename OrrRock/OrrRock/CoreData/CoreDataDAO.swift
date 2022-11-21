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
    func createData(info: VideoInfo) -> NSManagedObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "VideoInformation", into: context)
        
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(info.gymName, forKey: "gymName")
        entity.setValue(info.gymVisitDate, forKey: "gymVisitDate")
        entity.setValue(info.videoLocalIdentifier, forKey: "videoLocalIdentifier")
        entity.setValue(info.problemLevel, forKey: "problemLevel")
        entity.setValue(info.isSucceeded, forKey: "isSucceeded")
        
        saveData()
        
        return entity
    }
    
    // Core Data의 읽어 VideoInformation 클래스를 반환합니다.
    func readData() -> [VideoInformation] {
        var information: [VideoInformation] = []
        
        do {
            information = try context.fetch(VideoInformation.fetchRequest())
        } catch {
            print("CoreDataDAO ReadData Method \(error.localizedDescription)")
        }
        
        return information
    }
    
    // 암장 방문 날짜 및 이름 변경과 관련된 메소드
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
            print("CoreDataDAO UpdateDateAndGymData Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    // 문제 난이도 및 성패 변경과 관련된 메소드
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
            print("CoreDataDAO UpdateLevelAndPF Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    // 문제 즐겨찾기 여부 변경과 관련된 메소드
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
            print("CoreDataDAO UpdateFavorite Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    // 문제 피드백 수정과 관련된 메소드
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
            print("CoreDataDAO UpdateFeedback Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    // 단일 데이터 삭제를 위한 메소드
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
            print("CoreDataDAO DeleteData Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    // 전체 데이터 삭제를 위한 메소드
    func deleteAllData() {
        let objects = readData()
        
        if objects.count > 0 {
            for object in objects {
                context.delete(object)
            }
            saveData()
        }
    }
    
    // 추가한 데이터를 현재 context에 반영
    func saveData() {
        do {
            try context.save()
        } catch {
            print("CoreDataDAO SaveData Method \(error.localizedDescription)")
        }
    }
    
    // MARK: VisitedClimbingGym CoreData
    // 최근 방문한 클라이밍장명 자동완성을 위한 코어데이터 함수
    // 클라이밍장명을 매개변수로 받아 VisitedClimbingGym NSManagedObject에 추가
    func createVisitedClimbingGym(gymName: String) -> NSManagedObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "VisitedClimbingGym", into: context)
        
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(gymName, forKey: "name")
        entity.setValue(Date(), forKey: "createdDate")
        
        saveData()
        
        return entity
    }
    
    // CoreData를 읽어, VisitedClimbingGym 배열을 반환
    func readVisitedClimbingGym() -> [VisitedClimbingGym] {
        var result: [VisitedClimbingGym] = []
        
        do {
            result = try context.fetch(VisitedClimbingGym.fetchRequest())
        } catch {
            print("CoreDataDAO readVisitedClimbingGym Method \(error.localizedDescription)")
        }
        
        result.sort { $0.createdDate < $1.createdDate }
        
        return result
    }
    
    // 매개변수로 받아온 단일 데이터 삭제
    func deleteVisitedClimbingGym(deleteTarget: VisitedClimbingGym) {
        guard let id = deleteTarget.id else { return }
        let request = VisitedClimbingGym.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let visitedClimbingGym = try context.fetch(request)
            if let foundGym = visitedClimbingGym.first {
                context.delete(foundGym)
                saveData()
            }
        } catch {
            print("CoreDataDAO deleteVisitedClimbingGym Method \(error.localizedDescription)")
        }
    }
    
    // 단일 데이터 날짜를 최신으로 변경
    func updateVisitedClimbingGym(updateTarget: VisitedClimbingGym) {
        guard let id = updateTarget.id else { return }
        let request = VisitedClimbingGym.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let target = info.first {
                target.setValue(Date(), forKey: "createdDate")
            }
        } catch {
            print("CoreDataDAO updateVisitedClimbingGym Method \(error.localizedDescription)")
        }
        saveData()
    }
}
