//
//  SectionData.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/25.
//

import Foundation

struct SectionData {
    var orderOption: OrderOption
    var sortOption: SortOption
    var filterOption: FilterOption
    var gymName: String
    
    // 기본적으로는 클라이밍장 방문 일자
    // 암장 기준 정렬 시 최초 방문일지
    var primaryGymVisitDate: Date
    
    // 암장 기준 정렬 시 최근 방문일자
    // 암장 외 정렬 시 사용하지 않음 (nil 전달)
    var secondaryGymVisitDate: Date?
}
