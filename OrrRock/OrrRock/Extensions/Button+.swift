//
//  Button+.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//  버튼의 비활성화 상태시 색상을 선택할 수 있는 코드

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}

// 출처 : https://jmkim0213.github.io/ios/swift/ui/2019/02/05/button_background.html
