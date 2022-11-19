//
//  VideoSlider.swift
//  OrrRock
//
//  Created by Yeni Hwang on 2022/11/18.
//

import UIKit

class VideoSlider: UISlider {
    @IBInspectable var sliderHeight: CGFloat = 34
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSizeMake(bounds.width, sliderHeight))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
