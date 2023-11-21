//
//  DataRepository.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/25.
//

import Foundation

class DataRepository {
    
    var rawVideoInformation: [VideoInformation]
    var visitedClimbingGyms: [VisitedClimbingGym]
    
    
    init() {
        rawVideoInformation = []
        visitedClimbingGyms = []
    }
    
    func filterVideoInformation(filterOption: FilterOption) -> [VideoInformation] {
        
        switch filterOption {
        case .all:
            return rawVideoInformation
        case .favorite:
            return rawVideoInformation.filter({ $0.isFavorite == true })
        case .success:
            return rawVideoInformation.filter({ $0.isSucceeded == true})
        case .failure:
            return rawVideoInformation.filter({ $0.isSucceeded == false })
        }
    }
    
    func sortVideoInformation(filterOption: FilterOption, sortOption: SortOption) -> [[VideoInformation]] {
        
        var filteredInformation = filterVideoInformation(filterOption: filterOption)
        
        if filteredInformation.count == 0 {
            return []
        }
        
        var filteredInfoIndex = 0
        var currentSortedInformationIndex = 0
        
        var sortedVideoInformation: [[VideoInformation]] = []
        
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
            
            sortedVideoInformation.append([])
            var currentGymName = filteredInformation[filteredInfoIndex].gymName
            
            while filteredInfoIndex != filteredInformation.count {
                
                if filteredInformation[filteredInfoIndex].gymName == currentGymName {
                    sortedVideoInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                } else {
                    sortedVideoInformation.append([])
                    currentSortedInformationIndex += 1
                    sortedVideoInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                    currentGymName = filteredInformation[filteredInfoIndex].gymName
                }
                
                filteredInfoIndex += 1
                
            }
            
            for index in 0..<sortedVideoInformation.count {
                sortedVideoInformation[index].sort(by: {$0.gymVisitDate > $1.gymVisitDate})
            }
            
            return sortedVideoInformation
            
            // MARK: 클라이밍장 이름을 분류하는 케이스
            /* sort함수를 통해 클라이밍장 방문 날짜로 먼저 분류합니다.
             오름차순 이름으로 정렬된 filteredInformation이 만약 내림차순으로 구현되어야한다면 해당 배열을 reverse합니다.
             여기까지 작업이 완료되었다면 1차원 배열인 filteredInformation을 클라이밍장 방문 날짜별로 2차원 배열로 만들어줍니다.
             같은 날짜 하위에 다양한 날짜가 존재할 가능성이 있으므로 이를 내림차순으로 정렬하기 위해 1차원 배열 visitDateSortedArray를 만들어줍니다.
             여기까지 작업이 완료되었다면 1차원 배열인 gymNameSortedArray를 클라이밍장 이름, 날짜가 동일한 것들을 묶어 2차원 배열 finalSortedInformation로 만들어줍니다.
             */
        case .gymVisitDate:
            
            filteredInformation.sort(by: { $0.gymVisitDate > $1.gymVisitDate })
            
            sortedVideoInformation.append([])
            var currentGymVisitDate = filteredInformation[filteredInfoIndex].gymVisitDate.formatted(date: .numeric, time: .omitted)
            
            while filteredInfoIndex != filteredInformation.count {
                
                if filteredInformation[filteredInfoIndex].gymVisitDate.formatted(date: .numeric, time: .omitted) == currentGymVisitDate {
                    sortedVideoInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                } else {
                    sortedVideoInformation.append([])
                    currentSortedInformationIndex += 1
                    sortedVideoInformation[currentSortedInformationIndex].append(filteredInformation[filteredInfoIndex])
                    currentGymVisitDate = filteredInformation[filteredInfoIndex].gymVisitDate.formatted(date: .numeric, time: .omitted)
                }
                
                filteredInfoIndex += 1
                
            }
            
            currentSortedInformationIndex = -1
            
            var finalSortedInformation: [[VideoInformation]] = []
            
            for index in 0..<sortedVideoInformation.count {
                
                if sortedVideoInformation[index].count == 0 {
                    continue
                }
                
                let gymNameSortedArray = sortedVideoInformation[index].sorted(by: { $0.gymName > $1.gymName })
                
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
            
            return finalSortedInformation
        }
    }
    
    // 현재 정렬된 VideoInformation 2차원 배열을 reverse
    func reverseSort(sortedVideoInformation: [[VideoInformation]]) -> [[VideoInformation]] {
        return sortedVideoInformation.reversed()
    }
    
    func finalSortVideoInformation(filterOption: FilterOption, sortOption: SortOption, orderOption: OrderOption) -> [[VideoInformation]] {
        var information = sortVideoInformation(filterOption: filterOption, sortOption: sortOption)
        
        if orderOption == .descend {
            information = reverseSort(sortedVideoInformation: information)
        }
        
        return information
    }
    
    func createData(info: VideoInformation) {
        rawVideoInformation.append(info)
    }
    
    func updateDateData(videoInformation: VideoInformation, gymVisitDate: Date) {
        
        guard let id = videoInformation.id else { return }
        
        let target = rawVideoInformation.filter({ $0.id == id })
        target[0].gymVisitDate = gymVisitDate
    }
    
    func updateGymData(videoInformation: VideoInformation, gymName: String) {
        
        guard let id = videoInformation.id else { return }
        
        let target = rawVideoInformation.filter({ $0.id == id })
        target[0].gymName = gymName
    }
    
    func updateLevelAndPF(videoInformation: VideoInformation, problemLevel: Int, isSucceeded: Bool) {
        
        guard let id = videoInformation.id else { return }
        
        let target = rawVideoInformation.filter({ $0.id == id })
        target[0].problemLevel = Int16(problemLevel)
        target[0].isSucceeded = isSucceeded
    }
    
    func updateFavorite(videoInformation: VideoInformation, isFavorite: Bool) {
        
        guard let id = videoInformation.id else { return }
        
        let target = rawVideoInformation.filter({ $0.id == id })
        target[0].isFavorite = isFavorite
    }
    
    func updateFeedback(videoInformation: VideoInformation, feedback: String) {
        
        guard let id = videoInformation.id else { return }
        
        let target = rawVideoInformation.filter({ $0.id == id })
        target[0].feedback = feedback
    }
    
    func deleteData(videoInformation: VideoInformation) {
        
        let target = rawVideoInformation.filter({ $0 == videoInformation })
        if let index = rawVideoInformation.firstIndex(of: target[0]) {
            rawVideoInformation.remove(at: index)
        }
    }
    
    func deleteDataList(videoInformation: [VideoInformation]) {
        for information in videoInformation {
            deleteData(videoInformation: information)
        }
    }
    
    func deleteAllData() {
        rawVideoInformation.removeAll()
    }
    
    // MARK: VisitedClimbingGym DataRepository
    func createVisitedClimbingGym(visitedClimbingGym: VisitedClimbingGym) {
        visitedClimbingGyms.append(visitedClimbingGym)
        sortVisitedClimbingGym()
    }
    
    func sortVisitedClimbingGym() {
        visitedClimbingGyms.sort { $0.createdDate > $1.createdDate }
    }
    
    func deleteVisitedClimbingGym(deleteTarget: VisitedClimbingGym) {
        let target = visitedClimbingGyms.filter({ $0 == deleteTarget })
        if target.isEmpty { return }
        if let index = visitedClimbingGyms.firstIndex(of: target[0]) {
            visitedClimbingGyms.remove(at: index)
        }
    }
    
    func updateVisitedClimbingGym(updateTarget: VisitedClimbingGym) {
        guard let id = updateTarget.id else { return }
        
        let target = visitedClimbingGyms.filter({ $0.id == id })
        target[0].createdDate = Date()
        
        sortVisitedClimbingGym()
    }
}
