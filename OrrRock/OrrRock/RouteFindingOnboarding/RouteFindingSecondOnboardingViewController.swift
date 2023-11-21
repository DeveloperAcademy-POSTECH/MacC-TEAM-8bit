//
//  RouteFindingSecondOnboardingViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/27.
//

import UIKit

import SnapKit

class RouteFindingSecondOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables

    var isMovingToNextPage: Bool = false
    var isHandButtonMode: Bool = false {
        didSet {
            gestureView.isHandButton = isHandButtonMode
            
            handButton.tintColor = isHandButtonMode ? .orrWhite : .orrGray500
            footButton.tintColor = isHandButtonMode ? .orrGray500 : .orrWhite
        }
    }
    
    // MARK: View Components
    
    // TODO: house 이미지를 손, 발 이미지로 대체하기

    private lazy var handButton: UIButton = {
        let handButton = UIButton()
        handButton.backgroundColor = .clear
        handButton.setImage(UIImage(named: "activated_hand_button")!.withRenderingMode(.alwaysTemplate), for: .normal)
        handButton.tintColor = .orrGray500
        handButton.addAction(UIAction { _ in
            self.isHandButtonMode = true
        }, for: .touchUpInside)
        return handButton
    }()
    
    private lazy var footButton: UIButton = {
        let footButton = UIButton()
        footButton.backgroundColor = .clear
        footButton.setImage(UIImage(named: "activated_foot_button")!.withRenderingMode(.alwaysTemplate), for: .normal)
        footButton.tintColor = .orrGray500
        footButton.addAction(UIAction { _ in
            self.isHandButtonMode = false
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
    
    private lazy var gestureView: RouteFindingOnboardingTapViewController = {
        let view = RouteFindingOnboardingTapViewController()
        view.delegate = self
        
        return view
    }()
    
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isHandButtonMode = true
        descriptionView.text = "화면을 눌러\n손동작과 발동작을 추가할 수 있어요"
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
        
        view.addSubview(gestureView.view)
        gestureView.view.snp.makeConstraints {
            $0.edges.equalTo(backgroundImageView)
        }
        
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
        
        super.setUpSkipButtonLayout()
    }
}

extension RouteFindingSecondOnboardingViewController: RouteFindingOnboardingTapViewControllerDelegate {
    func buttonAdded() {
        if !isMovingToNextPage {
            isMovingToNextPage = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.triggerMoveToNextPage()
            }
        }
    }
}


protocol RouteFindingOnboardingTapViewControllerDelegate {
    func buttonAdded()
}

final class RouteFindingOnboardingTapViewController: UIViewController {
    
    var delegate: RouteFindingOnboardingTapViewControllerDelegate?
    var isHandButton: Bool = true
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeRoutePoint(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    func makeRoutePoint(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
            if sender.location(in: self.view).y < self.view.frame.maxY {
                addRoutePointButton(to: sender.location(in: self.view))
                print("\(sender.location(in: self.view))")
            }
        }
        
        delegate?.buttonAdded()
    }
    
    func addRoutePointButton(to location: CGPoint) {
        var button = isHandButton ? RouteFindingFeatureHandButton() : RouteFindingFeatureFootButton()
        self.view.addSubview(button)
        
        button.snp.makeConstraints{
            $0.centerX.equalTo(location.x)
            $0.centerY.equalTo(location.y)
        }
    }
}
