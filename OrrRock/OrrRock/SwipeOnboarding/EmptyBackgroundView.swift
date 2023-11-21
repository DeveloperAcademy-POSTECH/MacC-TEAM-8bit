//
//  emptyBackgroundView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/17.
//

import UIKit
import SnapKit
import Then

class EmptyBackgroundView: UIView {
    
    // 오토레이아웃의 시작점이 되는 값입니다. 변경시 류하에게 문의 주세요.
    let padding = 68
    
    private lazy var backgroundRightTiltView: UIView = .init().then {
        $0.backgroundColor = .orrGray200
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private lazy var backgroundLeftTiltView: UIView = .init().then {
        $0.backgroundColor = .orrGray100
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        
    }
    
    private lazy var backgroundCenterView: UIView = .init().then {
        $0.backgroundColor = .orrGray300
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
}

extension EmptyBackgroundView {
    
    func setUpLayout(){
        self.addSubview(backgroundRightTiltView)
        backgroundRightTiltView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.snp.leading).offset(padding)
            $0.trailing.equalTo(self.snp.trailing).offset(-padding)
            $0.height.equalTo(backgroundRightTiltView.snp.width).multipliedBy(1.641)
            backgroundRightTiltView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 36)
        }
        
        self.addSubview(backgroundLeftTiltView)
        backgroundLeftTiltView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.snp.leading).offset(padding)
            $0.trailing.equalTo(self.snp.trailing).offset(-padding)
            $0.height.equalTo(backgroundLeftTiltView.snp.width).multipliedBy(1.641)
            backgroundLeftTiltView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 36)
        }
        
        self.addSubview(backgroundCenterView)
        backgroundCenterView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.snp.leading).offset(padding)
            $0.trailing.equalTo(self.snp.trailing).offset(-padding)
            $0.height.equalTo(backgroundCenterView.snp.width).multipliedBy(1.641)
        }
    }
}
