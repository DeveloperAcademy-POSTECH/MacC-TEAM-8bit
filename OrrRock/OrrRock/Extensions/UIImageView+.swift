//
//  UIImageView+.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/18.
//

import UIKit

extension UIImageView {
    func setVideoBackgroundViewBorderColor(color: VideoBackgroundViewBorderColor,alpha: CGFloat) {
        var myColor = UIColor.orrWhite
        switch color {
        case.pass :
            myColor = .orrPass
        case .fail :
            myColor = .orrFail
        case .delete:
            myColor = .orrGray500
        case .clear :
            myColor = .orrWhite
        }
        self.layer.borderColor = myColor?.withAlphaComponent(1.0).cgColor
    }
}
