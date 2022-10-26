//
//  VideoCollectionView+DataSorting.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/25.
//

import Foundation

extension VideoCollectionViewController {
    
    func filterVideoInformation(videoInformation: [VideoInformation], filterOption: FilterOption) -> [VideoInformation] {
        
        switch filterOption {
        case .all:
            return videoInformation
        case .favorite:
            return videoInformation.filter({ $0.isFavorite == true })
        case .success:
            return videoInformation.filter({ $0.isSucceeded == true})
        case .failure:
            return videoInformation.filter({ $0.isSucceeded == false })
        }
    }
    
    func sortVideoInformation(videoInformation: [VideoInformation], sectionData: SectionData) -> [VideoInformation] {
        
        if videoInformation.count == 0 {
            print("해당하는 기준 조건의 영상이 존재하지 않습니다")
            return []
        }
        
        var filteredInformation: [VideoInformation] = []
        
        switch sectionData.sortOption {
            
        case .gymName:
            filteredInformation = filterVideoInformation(videoInformation: videoInformation, filterOption: sectionData.filterOption)
                .filter({$0.gymName == sectionData.gymName})
                .sorted(by: {$0.gymVisitDate > $1.gymVisitDate})
            
        case .gymVisitDate:
            filteredInformation = filterVideoInformation(videoInformation: videoInformation, filterOption: sectionData.filterOption)
                .filter({ $0.gymName == sectionData.gymName })
                .filter({ $0.gymVisitDate.formatted(date: .numeric, time: .omitted) == sectionData.primaryGymVisitDate.formatted(date: .numeric, time: .omitted) })
                .sorted(by: { $0.gymVisitDate < $1.gymVisitDate })
        }
        
        if sectionData.orderOption == .descend {
            filteredInformation.reverse()
        }
        
        return filteredInformation
    }
}

