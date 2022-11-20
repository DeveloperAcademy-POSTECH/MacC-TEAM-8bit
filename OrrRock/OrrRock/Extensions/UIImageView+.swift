//
//  UIImageView+.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/18.
//

import UIKit

extension UIImageView {
    func setVideoBackgroundViewBorderColor(color: VideoBackgroundViewBorderColor,alpha: CGFloat) {
        var r : CGFloat = 0.0
        var g : CGFloat = 0.0
        var b : CGFloat = 0.0
        
        switch color {
        case.pass :
            r = 48; g = 176; b = 199
        case .fail :
            r = 242; g = 52; b = 52
        case .clear :
            r = 255; g = 255; b = 255
        }
        self.layer.borderColor = UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha: alpha).cgColor
    }
}
