//
//  RouteFindingSecondOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingSecondOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables

    
    // MARK: View Components
    
    // TODO: house 이미지를 손, 발 이미지로 대체하기

    private lazy var handButton = {
        let handButton = UIButton()
        handButton.backgroundColor = .clear
        handButton.setImage(UIImage(systemName: "house"), for: .normal)
        handButton.tintColor = .orrWhite
        handButton.addAction(UIAction { _ in
                self.tapHandFootButton()
        }, for: .touchUpInside)
        return handButton
    }()
    
    private lazy var footButton = {
        let footButton = UIButton()
        footButton.backgroundColor = .clear
        footButton.setImage(UIImage(systemName: "house"), for: .normal)
        footButton.tintColor = .orrWhite
        footButton.addAction(UIAction { _ in
            self.tapHandFootButton()
        }, for: .touchUpInside)
        return footButton
    }()
    
    private lazy var footHandStackView: UIStackView = {
                
        let stackView = UIStackView(arrangedSubviews: [handButton, footButton])
        stackView.backgroundColor = .orrGray700
        // stackView의 width가 40이므로, cornerRadius의 값을 20으로 지정
        stackView.layer.cornerRadius = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override var descriptionView: UILabel {
        get { return super.descriptionView }
        set { self.descriptionView = newValue }
    }
    
    private lazy var handDescriptionView: UILabel = {
        let view = UILabel()
        view.text = "손동작 추가하기"
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.textColor = .orrWhite
        view.textAlignment = .center
        return view
    }()
    
    private lazy var footDescriptionView: UILabel = {
        let view = UILabel()
        view.text = "발동작 추가하기"
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.textColor = .orrWhite
        view.textAlignment = .center
        return view
    }()
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionView.text = "버튼을 눌러\n손동작과 발동작을 추가할 수 있어요"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Functions
    
    func tapHandFootButton() {
        delegate?.moveToNextPage()
    }
    
    // MARK: @objc Functions
}

    

extension RouteFindingSecondOnboardingViewController {
    
    // MARK: Set Up Functions
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(footHandStackView)
        footHandStackView.snp.makeConstraints {
            $0.centerY.equalTo(super.backgroundImageView.snp.centerY)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.height.equalTo(110)
            $0.width.equalTo(40)
        }
        
        view.addSubview(handDescriptionView)
        handDescriptionView.snp.makeConstraints {
            $0.centerY.equalTo(handButton.snp.centerY)
            $0.leading.equalTo(footHandStackView.snp.trailing).offset(OrrPd.pd16.rawValue)
        }
        
        view.addSubview(footDescriptionView)
        footDescriptionView.snp.makeConstraints {
            $0.centerY.equalTo(footButton.snp.centerY)
            $0.leading.equalTo(footHandStackView.snp.trailing).offset(OrrPd.pd16.rawValue)
        }
    }
}
