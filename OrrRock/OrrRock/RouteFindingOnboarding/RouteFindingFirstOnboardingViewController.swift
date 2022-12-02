//
//  RouteFindingFirstOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

import SnapKit

class RouteFindingFirstOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables
    
    
    // MARK: View Components
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "RouteFindingOnboardingHandImage")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override var descriptionView: UILabel {
        get { return super.descriptionView }
        set { self.descriptionView = newValue }
    }
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.setTitle("방법 살펴보기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        btn.addAction(UIAction(handler: { _ in
            self.triggerMoveToNextPage()
        }), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var underlinedSkipButton: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle("이미 잘 할 수 있어요".underLineAttribute(color: .orrGray500!), for: .normal)
        btn.addAction(UIAction(handler: { _ in
            self.triggerSkipOnboarding()
        }), for: .touchUpInside)
        return btn
    }()
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionView.text = "이제부터 루트 파인딩을 기록해요\n방법을 살펴볼까요?"
        skipButton.setAttributedTitle("이미 잘 할 수 있어요".underLineAttribute(color: .orrGray500!), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Functions
    
    // MARK: @objc Functions
}



extension RouteFindingFirstOnboardingViewController {
    
    // MARK: Set Up Functions
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-17)
            $0.width.equalTo(96)
            $0.height.equalTo(80)
        }
        
        descriptionView.snp.removeConstraints()
        descriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(33)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.snp.bottom).offset(-OrrPd.pd36.rawValue)
            $0.horizontalEdges.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(underlinedSkipButton)
        underlinedSkipButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(nextButton.snp.top).offset(-OrrPd.pd4.rawValue)
        }
    }
}
