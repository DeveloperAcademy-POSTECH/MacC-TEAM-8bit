//
//  UnderlinedTextField.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/23.
//  텍스트필드에 언더라인을 추가한 버전입니다.

import UIKit

import SnapKit
import Then

class UnderlinedTextField: UITextField, UITextFieldDelegate {
    
    let underlineLayer = CALayer()
    let warningLabel: UILabel = .init().then {
        $0.text = "20자 이내로 적어주세요"
        $0.textColor = .orrGray400
        $0.textAlignment = .left
    }
    
    /// Size the underline layer and position it as a one point line under the text field.
    func setUpUnderlineLayer() {
        var frame = self.bounds
        frame.origin.y = frame.size.height - 1
        frame.size.height = 2
        
        underlineLayer.frame = frame
        underlineLayer.backgroundColor = UIColor.orrUPBlue?.cgColor
    }
    
    func setLimitWarningLabel() {
        self.addSubview(warningLabel)
        
        warningLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.snp.bottom).offset(12)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        return newLength <= 20
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
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.delegate = self
        setUpUnderlineLayer()
        setLimitWarningLabel()
    }
}
