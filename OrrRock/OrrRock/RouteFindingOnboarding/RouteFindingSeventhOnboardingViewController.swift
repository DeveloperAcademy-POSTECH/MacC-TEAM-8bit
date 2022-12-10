//
//  RouteFindingSeventhOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingSeventhOnboardingViewController: RouteFindingOnboardingParentViewController {

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
        btn.setTitle("시작", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.addAction(UIAction(handler: { _ in
            self.triggerSkipOnboarding()
        }), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 40))
        button.layer.cornerRadius = 20
        button.backgroundColor = .orrGray700
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.orrWhite, for: .normal)
        button.setTitleColor(.orrGray500, for: .highlighted)
        button.addAction(UIAction { _ in
            self.triggerSkipOnboarding()
        }, for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionView.text = "기록한 루트 파인딩은\n완료를 통해 저장할 수 있어요"
    }
    
    // MARK: Functions
    
    // MARK: @objc Functions
}
    


extension RouteFindingSeventhOnboardingViewController {
    
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
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(64)
        }
        
        skipButton.removeFromSuperview()
    }
}
