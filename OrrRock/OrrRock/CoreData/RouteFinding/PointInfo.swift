//
//  PointInfo.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import Foundation

struct PointInfo: Equatable {
    var footOrHand: FootOrHand
    var isForce: Bool
    var position: CGPoint
    var forceDirection: ForceDirection
}
