//
//  RouteFindingFeatureHandButton.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/30.
//

import UIKit

class RouteFindingFeatureHandButton: RouteFindingFeatureButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImage(named: "hand_point_button")!.resized(to: CGSize(width: 40, height: 40))
        self.imageView?.contentMode = .scaleToFill
        self.setImage(image, for: .normal)
//        self.setImage(UIImage(named: "hand_point_button")!.resized(to: CGSize(width: 40, height: 40)), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
