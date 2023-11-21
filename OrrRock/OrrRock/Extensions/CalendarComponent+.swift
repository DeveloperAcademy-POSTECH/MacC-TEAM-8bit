//
//  CalenderComponent+.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/19.
//

import Foundation

extension Calendar.Component {
    
    func toString() -> String {
        switch self {
        case .weekday:
            return "주"
        case .month:
            return "달"
        case .year:
            return "년"
        default:
            return ""
        }
    }
}
