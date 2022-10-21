//
//  videoFilterEnum.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/21.
//

import Foundation

enum VideoFilterEnum {
    case whole, liked, success, fail
    
    var iconName: String {
        switch self {
        case .whole:
            return "photo.on.rectangle.angled"
        case .liked:
            return "heart"
        case .success:
            return "circle"
        case .fail:
            return "multiply"
        }
    }
}
