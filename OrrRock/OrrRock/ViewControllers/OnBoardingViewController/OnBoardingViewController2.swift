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
        label.text = "오르락 시작하기"
        return label
    }()
    
    private lazy var subLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.text = "클라이밍 발견하기"
        return label
    }()
    
    private lazy var labelImage1: UIImageView = {
        let image = UIImage(named: "OnboardingImage2")
        let label = UIImageView(image: image)
        return label
    }()
    
    
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchDown)
        btn.setTitle("계속", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setUpLayout()
        // Do any additional setup after loading the view.
    }
    
    
    private func setUpDelegate(){
        
        
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
        
//        view.addSubview(nextButton)
//        nextButton.snp.makeConstraints{
//            $0.centerX.equalTo(view)
//            $0.bottom.equalTo(view).offset(-34)
//            $0.leading.equalTo(view).offset(orrPadding.padding3.rawValue)
//            $0.trailing.equalTo(view).offset(-orrPadding.padding3.rawValue)
//            $0.height.equalTo(56)
//        }
    }
    
    @objc
    private func pressNextButton(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "watchOnBoard")
        //이동
    }
}
