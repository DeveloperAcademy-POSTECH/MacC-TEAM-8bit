//
//  Date+.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/22.
//

import Foundation

extension Date {
    //MARK: Date -> String 타입 변환 메서드
    func timeToString() -> String { // "yyyy년 M월 d일"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        
        return dateFormatter.string(from: self)
    }
    
    //MARK: RouteFindingMainSampleDataGenerate
    static func randomBetween(start: Date, end: Date) -> Date {
        var startDate = start
        var endDate = end
        if endDate < startDate {
            let temp = startDate
            startDate = endDate
            endDate = temp
        }
        let randomTime = TimeInterval.random(in: startDate.timeIntervalSinceNow...endDate.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: randomTime)
    }
}
