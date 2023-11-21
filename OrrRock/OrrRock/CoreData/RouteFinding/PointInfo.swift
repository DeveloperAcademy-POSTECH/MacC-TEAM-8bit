//
//  PointInfo.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/24.
//

import Foundation

struct PointInfo: Equatable {
    var id: UUID
    var footOrHand: FootOrHand
    var isForce: Bool
    var position: CGPoint
    var forceDirection: ForceDirection
}
