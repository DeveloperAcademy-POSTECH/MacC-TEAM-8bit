//
//  RouteFindingOnboardingParentViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/27.
//

import UIKit
import Then

class RouteFindingOnboardingParentViewController: UIViewController {
    
    // MARK: Variables
    
    let backgroundImage: UIImage
    var delegate: RouteFindingOnboardingPaginationDelegate?
    
    // MARK: View Components
    
    lazy var backgroundImageView: UIImageView = .init().then {
        
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.windows.first
        let contentHeight = view.frame.height - Double(((window?.safeAreaInsets.top)! + (window?.safeAreaInsets.bottom)!))
        let contentWidth = view.frame.width
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        $0.image = backgroundImage
        $0.backgroundColor = .white
        $0.layer.addSublayer(gradientLayer)
    }
    
    lazy var descriptionView: UILabel = .init().then {
        $0.text = "이 곳에 설명이 보여집니다\ndescriptionView에 설명을 작성해주세요"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .orrGray100
        $0.textAlignment = .center
    }
    
    lazy var skipButton: UIButton = .init().then {
        $0.frame = CGRect(x: 0, y: 0, width: 64, height: 40)
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .orrGray700
        $0.setTitle("SKIP", for: .normal)
        $0.setTitleColor(.orrWhite, for: .normal)
        $0.setTitleColor(.orrGray500, for: .highlighted)
        $0.addAction(UIAction { _ in
            self.triggerSkipOnboarding()
        }, for: .touchUpInside)
    }
    
    // MARK: Life Cycle Functions
    
    init(backgroundImage: UIImage) {
        self.backgroundImage = backgroundImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setUpLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Functions
    
    func triggerMoveToNextPage() {
        delegate?.moveToNextPage()
    }
    
    func triggerSkipOnboarding() {
        delegate?.skipOnboarding()
    }
    
    // MARK: @objc Functions
}



extension RouteFindingOnboardingParentViewController {
    
    // MARK: Set Up Functions
    @objc
    func setUpLayout() {
        view.addSubview(backgroundImageView)
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.windows.first
        let contentHeight = view.frame.height - (window?.safeAreaInsets.top)! + (window?.safeAreaInsets.bottom)!
        let contentWidth = view.frame.width
        let widthFirst: Bool = contentWidth < (contentHeight - 69) * 9 / 16
        backgroundImageView.snp.makeConstraints {
            if widthFirst {
                $0.width.equalTo(contentWidth)
                $0.height.equalTo(contentWidth * 16 / 9)
            } else {
                $0.height.equalTo(contentHeight - 69)
                $0.width.equalTo((contentHeight - 69) * 9 / 16)
            }
            $0.top.equalTo(view.forLastBaselineLayout.snp_topMargin)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(descriptionView)
        self.descriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(backgroundImageView.snp.bottom).inset(OrrPd.pd72.rawValue)
        }
    }
    
    @objc
    func setUpSkipButtonLayout() {
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.trailing.equalTo(view.snp.trailing).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
    }
}
