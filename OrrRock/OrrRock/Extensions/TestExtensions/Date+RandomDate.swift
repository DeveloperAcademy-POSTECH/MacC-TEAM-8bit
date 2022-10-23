//
//  Date+RandomDate.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/22.
//

import Foundation

//https://gist.github.com/nbasham/c219d8c8c773d2c146c526dfccb4353b
extension Date {
    static func random(in range: Range<Date>) -> Date {
        Date(
            timeIntervalSinceNow: .random(
                in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
            )
        )
    }
}
