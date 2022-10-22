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
    
    private var rawVideoInformation: [VideoInformation] = []
    private var sortedVideoInformation: [[VideoInformation]] = []
    
    init() {
        rawVideoInformation = readData()
    }
    
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
        
        let originInformation = readData()
        
        switch filterOption {
        case .all:
            return originInformation
        case .favorite:
            return originInformation.filter({ $0.isFavorite == true })
        case .success:
            return originInformation.filter({ $0.isSucceeded == true})
        case .failure:
            return originInformation.filter({ $0.isSucceeded == false })
        }
    }
    
    func sortVideoInformation(videoInformation: [VideoInformation], sortOption: SortOption) {
        
        self.sortedVideoInformation.removeAll()
        
        var filteredInformation = videoInformation
        var sortedInformation: [[VideoInformation]] = []
        
        var filteredInfoIndex = 0
        var currentSortedInformationIndex = 0
        
        switch sortOption {
            
            // MARK: 클라이밍장 이름을 분류하는 케이스
            /* sort함수를 통해 클라이밍장 이름으로 먼저 분류합니다.
             오름차순 이름으로 정렬된 filteredInformation이 만약 내림차순으로 구현되어야한다면 해당 배열을 reverse합니다.
             여기까지 작업이 완료되었다면 1차원 배열인 filteredInformation을 클라이밍장 이름별로 2차원 배열로 만들어줍니다.
             같은 이름 하위에 다양한 날짜가 존재하므로 이를 오름차순으로 정렬하기 위해 1차원 배열 visitDateSortedArray를 만들어줍니다.
             여기까지 작업이 완료되었다면 1차원 배열인 visitDateSortedArray를 클라이밍장 이름, 날짜가 동일한 것들을 묶어 2차원 배열 finalSortedInformation로 만들어줍니다.
             */
        case .gymName:
            
            filteredInformation.sort(by: { $0.gymName < $1.gymName })
            
            sortedInformation.append([])
            var currentGymName = filteredInformation[filteredInfoIndex].gymName
            
            while filteredInfoIndex != filteredInformation.count {
                
                if filteredInformation[filteredInfoIndex].gymName == currentGymName {
                    sortedInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                } else {
                    sortedInformation.append([])
                    currentSortedInformationIndex += 1
                    sortedInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                    currentGymName = filteredInformation[filteredInfoIndex].gymName
                }
                
                filteredInfoIndex += 1
                
            }
            
            for index in 0..<sortedInformation.count {
                sortedInformation[index].sort(by: {$0.gymVisitDate > $1.gymVisitDate})
            }
            
            self.sortedVideoInformation = sortedInformation
            
            // MARK: 클라이밍장 이름을 분류하는 케이스
            /* sort함수를 통해 클라이밍장 방문 날짜로 먼저 분류합니다.
             오름차순 이름으로 정렬된 filteredInformation이 만약 내림차순으로 구현되어야한다면 해당 배열을 reverse합니다.
             여기까지 작업이 완료되었다면 1차원 배열인 filteredInformation을 클라이밍장 방문 날짜별로 2차원 배열로 만들어줍니다.
             같은 날짜 하위에 다양한 날짜가 존재할 가능성이 있으므로 이를 내림차순으로 정렬하기 위해 1차원 배열 visitDateSortedArray를 만들어줍니다.
             여기까지 작업이 완료되었다면 1차원 배열인 gymNameSortedArray를 클라이밍장 이름, 날짜가 동일한 것들을 묶어 2차원 배열 finalSortedInformation로 만들어줍니다.
             */
        case .gymVisitDate:
            
            filteredInformation.sort(by: { $0.gymVisitDate < $1.gymVisitDate })
            
            sortedInformation.append([])
            var currentGymVisitDate = filteredInformation[filteredInfoIndex].gymVisitDate
            
            while filteredInfoIndex != filteredInformation.count {
                
                if filteredInformation[filteredInfoIndex].gymVisitDate == currentGymVisitDate {
                    sortedInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                } else {
                    sortedInformation.append([])
                    currentSortedInformationIndex += 1
                    sortedInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                    currentGymVisitDate = filteredInformation[filteredInfoIndex].gymVisitDate
                }
                
                filteredInfoIndex += 1
                
            }
            
            currentSortedInformationIndex = -1
            
            var finalSortedInformation: [[VideoInformation]] = []
            
            for index in 0..<sortedInformation.count {
                
                if sortedInformation[index].count == 0 {
                    continue
                }
                
                let gymNameSortedArray = sortedInformation[index].sorted(by: { $0.gymName < $1.gymName })
                
                filteredInfoIndex = 0
                
                var currentGymName = gymNameSortedArray[filteredInfoIndex].gymName
                
                finalSortedInformation.append([])
                currentSortedInformationIndex += 1
                
                while filteredInfoIndex != gymNameSortedArray.count {
                    
                    if gymNameSortedArray[filteredInfoIndex].gymName == currentGymName {
                        finalSortedInformation[currentSortedInformationIndex].append(gymNameSortedArray[filteredInfoIndex])
                    } else {
                        finalSortedInformation.append([])
                        currentSortedInformationIndex += 1
                        finalSortedInformation[currentSortedInformationIndex].append(gymNameSortedArray[filteredInfoIndex])
                        currentGymName = gymNameSortedArray[filteredInfoIndex].gymName
                    }
                    
                    filteredInfoIndex += 1
                    
                }
            }
            
            self.sortedVideoInformation = finalSortedInformation
        }
    }
    
    // 현재 정렬된 VideoInformation 2차원 배열을 reverse
    func reverseSort() {
        sortedVideoInformation.reverse()
    }

}
