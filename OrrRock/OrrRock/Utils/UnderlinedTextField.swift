//
//  UnderlinedTextField.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//  텍스트필드에 언더라인을 추가한 버전입니다.

import UIKit

class UnderlinedTextField: UITextField {
    
    let underlineLayer = CALayer()
    
    /// Size the underline layer and position it as a one point line under the text field.
    func setUpUnderlineLayer() {
        var frame = self.bounds
        frame.origin.y = frame.size.height - 1
        frame.size.height = 1
        
        underlineLayer.frame = frame
        underlineLayer.backgroundColor = UIColor.orrUPBlue?.cgColor
    }
    
    // In `init?(coder:)` Add our underlineLayer as a sublayer of the view's main layer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.addSublayer(underlineLayer)
    }
    
    // in `init(frame:)` Add our underlineLayer as a sublayer of the view's main layer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(underlineLayer)
    }
    
    // Any time we are asked to update our subviews,
    // adjust the size and placement of the underline layer too
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpUnderlineLayer()
    }
}
