//
//  RouteFindingFeatureFootButton.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/30.
//

import UIKit

class RouteFindingFeatureFootButton: RouteFindingFeatureButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "foot_point_button")!.resized(to: CGSize(width: 40, height: 40)), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
