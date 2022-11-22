//
//  SwipeOnboardingSecondViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/17.
//

import UIKit
import SnapKit


/* MARK: 추가 작업사항
    1. 상단에 레벨 피커 추가
    2. 레벨 피커 위의 문구는 화면 크기 혹은 홈버튼 유무에 따라 보이거나 안보이게 처리 해야함
 */

class SwipeOnboardingSecondViewController: UIViewController {
    
    // 오토레이아웃의 시작점이 되는 값입니다. 변경시 류하에게 문의 주세요.
    let padding = 68
    var delegate: SwipeOnboardingViewControllerDelegate?
    var changedLevelPicker = false
    
    private lazy var BackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let image = UIImage(named: "SwipeOnboardingImage2")
        let view = UIImageView(image: image)
        return view
    }()
    
    private lazy var newLevelPickerView: NewLevelPickerView = {
        let view = NewLevelPickerView()
        view.pickerSelectValue = 0
        view.delegate = self
        view.customTitle = "슬라이드 해주세요"
        return view
    }()
    
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pressSkipButton), for: .touchUpInside)
        btn.setAttributedTitle("SKIP".underLineAttribute(), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
}

extension SwipeOnboardingSecondViewController: NewLevelPickerViewDelegate{
    
    func didLevelChanged(selectedLevel: Int) {
        guard changedLevelPicker else{
            self.changedLevelPicker = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.pressNextButton()
            }
            return
        }
    }
    
}
//MARK: 함수 모음
extension SwipeOnboardingSecondViewController {
    
    @objc
    func pressNextButton() {
        self.delegate?.changeNextView()
    }
    
    @objc
    func pressSkipButton() {
        self.delegate?.skipOnboarding()
    }
}

//MARK: 오토레이아웃
extension SwipeOnboardingSecondViewController {
    
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

        view.addSubview(newLevelPickerView)
        newLevelPickerView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(mainImageView.snp.top)
        }
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd16.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
    }
}


