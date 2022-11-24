//
//  ForceDirection.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import Foundation

enum ForceDirection: Int {
    case pi0,pi1, pi2, pi3, pi4, pi5, pi6, pi7
    
    func forceDirectionToRadian() -> Double {
        return Double((self.rawValue - 1) / 2) * .pi
    }
}
