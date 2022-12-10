//
//  SwipeOnboardingFirstViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/16.
//

import UIKit
import SnapKit

class SwipeOnboardingFirstViewController: UIViewController {
    
    // 오토레이아웃의 시작점이 되는 값입니다. 변경시 류하에게 문의 주세요.
    let padding = 68
    var delegate: SwipeOnboardingViewControllerDelegate?
    var chekNextbuttonClick = false
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        btn.setTitle("방법 살펴보기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return btn
    }()
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pressSkipButton), for: .touchUpInside)
        btn.setAttributedTitle("이미 잘 할 수 있어요".underLineAttribute(color: UIColor(hex: "#969696")), for: .normal)
        return btn
    }()
    
    private lazy var BackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let image = UIImage(named: "SwipeOnboardingImage1")
        let view = UIImageView(image: image)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        view.backgroundColor = .orrGray050
    }
}

//MARK: 함수 모음
extension SwipeOnboardingFirstViewController {
    
    @objc
    func pressNextButton() {
        guard chekNextbuttonClick else {
            self.chekNextbuttonClick = true
            self.delegate?.changeNextView()
            return
        }
    }
    
    @objc
    func pressSkipButton() {
        self.delegate?.skipOnboarding()
    }
}

//MARK: 오토레이아웃
extension SwipeOnboardingFirstViewController {
    
    private func setUpLayout(){
        
        view.addSubview(BackgroundView)
        BackgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.height.equalTo(view.snp.height)
            $0.width.equalTo(view.snp.width)
            BackgroundView.setUpLayout()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd16.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(nextButton.snp.top).offset(-OrrPd.pd4.rawValue)
        }
        
        view.addSubview(mainImageView)
        mainImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(view.snp.leading).offset(padding)
            $0.trailing.equalTo(view.snp.trailing).offset(-padding)
            $0.height.equalTo(mainImageView.snp.width).multipliedBy(1.641)
        }
    }
}

