//
//  SwipeOnboardingFourthViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/17.
//

import UIKit
import SnapKit
import Then

class SwipeOnboardingFourthViewController: UIViewController {
    
    // 오토레이아웃의 시작점이 되는 값입니다. 변경시 류하에게 문의 주세요.
    let padding = 68
    var delegate: SwipeOnboardingViewControllerDelegate?
    // 제스쳐를 추가하는코드
    let gesture = UIPanGestureRecognizer()
    let cornerRadius: CGFloat = 10
    var chekNextbuttonClick =  false
    
    private lazy var BackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    private lazy var mainImageView: UIImageView = .init().then {
        $0.image = UIImage(named: "SwipeOnboardingImage4")
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = cornerRadius
        $0.layer.borderColor = UIColor.orrWhite?.cgColor
        $0.layer.zPosition = 1
        $0.isUserInteractionEnabled = true
        gesture.addTarget(self, action: #selector(handlerCard))
        $0.addGestureRecognizer(gesture)
    }
    
    private lazy var failArrowImageView: UIImageView = .init().then {
        $0.image = UIImage(named: "fail_arrow")
    }
    
    private lazy var failButton: CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "fail_icon"), for: .normal)
        btn.addTarget(self, action: #selector(didFailButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pressSkipButton), for: .touchUpInside)
        btn.setAttributedTitle("SKIP".underLineAttribute(color: .orrUPBlue!), for: .normal)
        return btn
    }()
    
    private lazy var paddigView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        view.backgroundColor = .orrGray050
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               mainImageView.layer.borderColor = UIColor.orrWhite?.cgColor
       }
    }
    
}

//MARK: 함수 모음
extension SwipeOnboardingFourthViewController {
    
    @objc
    private func didFailButton() {
        mainImageView.layer.borderColor = UIColor.orrFail?.cgColor
        UIView.animate(withDuration: 0.3, animations: { [self] in
            mainImageView.transform = CGAffineTransform(rotationAngle: -0.4)
            mainImageView.center = CGPoint(x: mainImageView.center.x - view.bounds.width, y: mainImageView.center.y + 30)
        }){ [self] _ in
            mainImageView.alpha = 0.0
            pressNextButton()
        }
    }
    
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
    
    @objc
    private func handlerCard(_ gesture: UIPanGestureRecognizer) {
        if let mainImageCard = gesture.view as? UIImageView {
            let point = gesture.translation(in: view)
            blockButton()
            mainImageCard.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x < 0 {
                mainImageCard.setVideoBackgroundViewBorderColor(color: .fail, alpha: -rotationAngle * 10)
            } else {
                mainImageCard.setVideoBackgroundViewBorderColor(color: .clear, alpha: 1.0)
            }
            
            mainImageCard.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            if gesture.state == .ended {
                if mainImageCard.center.x < self.view.bounds.width / 3 {
                    mainImageCard.alpha = 0
                    pressNextButton()
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    mainImageCard.center = self.BackgroundView.center
                    mainImageCard.transform = .identity
                    mainImageCard.setVideoBackgroundViewBorderColor(color: .clear, alpha: 1)
                    self.view.isUserInteractionEnabled = false
                } completion: { [self]_ in
                    unblockButton()
                    view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func blockButton(){
        self.failButton.isEnabled = false
        self.skipButton.isEnabled = false
    }
    
    func unblockButton(){
        self.failButton.isEnabled = true
        self.skipButton.isEnabled = true
    }
    
}

//MARK: 오토레이아웃
extension SwipeOnboardingFourthViewController {
    
    private func setUpLayout(){
        
        view.addSubview(BackgroundView)
        BackgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.height.equalTo(view.snp.height)
            $0.width.equalTo(view.snp.width)
            BackgroundView.setUpLayout()
        }

        view.addSubview(mainImageView)
        mainImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(view.snp.leading).offset(padding)
            $0.trailing.equalTo(view.snp.trailing).offset(-padding)
            $0.height.equalTo(mainImageView.snp.width).multipliedBy(1.641)
        }
        
        view.addSubview(failArrowImageView)
        failArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(view.snp.centerY).multipliedBy(0.93)
            $0.leading.equalTo(view.snp.leading).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(mainImageView.snp.leading).offset(-OrrPd.pd24.rawValue)
            $0.height.equalTo(failArrowImageView.snp.width).multipliedBy(0.708)
        }
        
        view.addSubview(paddigView)
        paddigView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(mainImageView.snp.leading)
            $0.trailing.equalTo(mainImageView.snp.trailing)
        }
        
        paddigView.addSubview(failButton)
        failButton.snp.makeConstraints {
            $0.centerY.equalTo(paddigView.snp.centerY).multipliedBy(0.7)
            $0.leading.equalTo(paddigView.snp.leading)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalToSuperview().offset(-OrrPd.pd16.rawValue)
        }
    }
}

