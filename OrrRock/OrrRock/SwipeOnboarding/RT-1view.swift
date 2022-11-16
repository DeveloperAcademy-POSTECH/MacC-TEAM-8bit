//
//  RT-1view.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/17.
//

import UIKit
import SnapKit

class RT_1view: UIView {
    
    private lazy var backgroundRightTiltView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(hex: "EEEEEE")
        //        view.backgroundColor =  .black
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backgroundLeftTiltView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray1
        //        view.backgroundColor =  .purple
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var backgroundCenterView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray3
        //        view.backgroundColor =  .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let ppap = 70
}

extension RT_1view {
    
     func setUpLayout(){
        self.addSubview(backgroundRightTiltView)
        backgroundRightTiltView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.snp.leading).offset(ppap)
            $0.trailing.equalTo(self.snp.trailing).offset(-ppap)
            $0.height.equalTo(backgroundRightTiltView.snp.width).multipliedBy(1.641)
            backgroundRightTiltView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 36)
        }
        
        self.addSubview(backgroundLeftTiltView)
        backgroundLeftTiltView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.snp.leading).offset(ppap)
            $0.trailing.equalTo(self.snp.trailing).offset(-ppap)
            $0.height.equalTo(backgroundLeftTiltView.snp.width).multipliedBy(1.641)
            backgroundLeftTiltView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 36)
        }
        
        self.addSubview(backgroundCenterView)
        backgroundCenterView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.snp.leading).offset(ppap)
            $0.trailing.equalTo(self.snp.trailing).offset(-ppap)
            $0.height.equalTo(backgroundCenterView.snp.width).multipliedBy(1.641)
        }
    }
}
