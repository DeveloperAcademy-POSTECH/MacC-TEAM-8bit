//
//  SwipeOnboardingFifthViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/17.
//

import UIKit
import SnapKit
import Then

class SwipeOnboardingFifthViewController: UIViewController {
    // 오토레이아웃의 시작점이 되는 값입니다. 변경시 류하에게 문의 주세요.
    let padding = 68
    var delegate: SwipeOnboardingViewControllerDelegate?

    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.addTarget(self, action: #selector(pressSkipButton), for: .touchUpInside)
        btn.setTitle("시작하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return btn
    }()
    
    
    private lazy var BackgroundView: EmptyBackgroundView = .init()
    
    private lazy var mainImageView: UIImageView = .init().then {
        $0.image = UIImage(named: "SwipeOnboardingImage5")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        view.backgroundColor = .orrGray050
    }
}

//MARK: 함수 모음
extension SwipeOnboardingFifthViewController {
    @objc
    func pressSkipButton() {
        self.delegate?.skipOnboarding()
    }
}

//MARK: 오토레이아웃
extension SwipeOnboardingFifthViewController {
    
    private func setUpLayout(){
        
        view.addSubview(BackgroundView)
        BackgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.height.equalTo(view.snp.height)
            $0.width.equalTo(view.snp.width)
            BackgroundView.setUpLayout()
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd16.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
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

