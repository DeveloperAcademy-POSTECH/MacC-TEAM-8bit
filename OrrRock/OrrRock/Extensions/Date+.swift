//
//  Date+.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/22.
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
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
}
