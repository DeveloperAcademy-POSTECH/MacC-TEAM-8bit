//
//  UIview+.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/08.
//

import Foundation

extension UIView {

    static func spacer(size: CGFloat = 10, for layout: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let spacer = UIView()

        if layout == .horizontal {
            spacer.widthAnchor.constraint(equalToConstant: size).isActive = true
        } else {
            spacer.heightAnchor.constraint(equalToConstant: size).isActive = true
        }

        return spacer
    }
}
