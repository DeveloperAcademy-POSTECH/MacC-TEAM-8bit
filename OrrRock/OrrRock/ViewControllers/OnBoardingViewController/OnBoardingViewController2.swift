//
//  OnBoardingViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/26.
//

import UIKit
import SnapKit

class OnBoardingViewController2: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.text = "홀드를 잡고 오르는"
        return label
    }()
    
    private lazy var subLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.text = "모습을 기록해서"
        return label
    }()
    
    private lazy var labelImage1: UIImageView = {
        let image = UIImage(named: "OnboardingImage2")
        let label = UIImageView(image: image)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    private func setUpLayout(){
        view.backgroundColor = .orrWhite
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(125)
        }
        view.addSubview(subLabel1)
        subLabel1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        view.addSubview(labelImage1)
        labelImage1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subLabel1.snp.bottom).offset(29)
        }
    }
    
}
