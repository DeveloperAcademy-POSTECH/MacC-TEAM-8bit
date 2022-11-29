//
//  RouteFindingLevelSaveViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/29.
//

import UIKit

import SnapKit

final class RouteFindingLevelSaveViewController: UIViewController {
    
    private var cards: [SwipeableCardVideoView?] = []
    private var currentSelectedLevel = 0
    
    let gymNameLabel : UILabel = {
        let label = UILabel()
        label.text = "난이도를 선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .orrBlack
        return label
    }()
    
    private lazy var newLevelPickerView: NewLevelPickerView = {
        let view = NewLevelPickerView()
        view.pickerSelectValue = 0
        view.delegate = self
        view.customTitle = "슬라이드 해주세요"

        return view
    }()
    
    private lazy var levelButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .orrGray500
        
        return imageView
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.orrUPBlue!, for: .normal)
        button.setBackgroundColor(.orrGray300!, for: .disabled)
        button.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orrWhite
        overrideUserInterfaceStyle = .dark

        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc final func pressNextButton() {
        
        let routeFindingLevelSaveViewController = RouteFindingLevelSaveViewController()
        navigationController?.pushViewController(routeFindingLevelSaveViewController, animated: true)
    }
}

extension RouteFindingLevelSaveViewController: NewLevelPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: Int) {
        currentSelectedLevel = selectedLevel
    }
    
}

private extension RouteFindingLevelSaveViewController {
    
    func setUpLayout() {
        
        view.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OrrPd.pd72.rawValue)
            $0.height.equalTo(26)
        }
        
        view.addSubview(newLevelPickerView)
        newLevelPickerView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(120)
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(OrrPd.pd36.rawValue)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).inset(OrrPd.pd36.rawValue)
            $0.leading.trailing.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
    }
}
