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
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        button.tintColor = .white
        button.addAction(UIAction { _ in
            self.goBackAction()
        }, for: .touchUpInside)
        
        return button
    }()
    
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
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        
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
        // TODO: 코어 데이터에 저장하는 로직 추가
    }
    
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RouteFindingLevelSaveViewController: NewLevelPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: Int) {
        currentSelectedLevel = selectedLevel
    }
    
}

private extension RouteFindingLevelSaveViewController {
    
    func setUpLayout() {
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        view.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(exitButton).offset(OrrPd.pd72.rawValue)
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
            $0.leading.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
    }
}
