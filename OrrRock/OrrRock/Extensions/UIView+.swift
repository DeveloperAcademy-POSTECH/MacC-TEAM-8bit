//
//  UIView+.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/08.
//  uikit의 스택뷰에서 SwiftUI 처럼 spacer를 사용하기위한 extension입니다.

import UIKit

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
    
    // UIView를 UIImage로 변환해주는 extension
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
