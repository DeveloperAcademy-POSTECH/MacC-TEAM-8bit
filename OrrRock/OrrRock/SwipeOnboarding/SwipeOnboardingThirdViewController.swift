//
//  SwipeOnboardingThirdViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/17.
//

import UIKit
import SnapKit

class SwipeOnboardingThirdViewController: UIViewController {

    // 오토레이아웃의 시작점이 되는 값입니다. 변경시 류하에게 문의 주세요.
    let padding = 68
    var delegate: SwipeOnboardingViewControllerDelegate?
    
    private lazy var BackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let image = UIImage(named: "SwipeOnboardingImage3")
        let view = UIImageView(image: image)
        return view
    }()
    
    private lazy var successArrowImageView: UIImageView = {
        let image = UIImage(named: "success_arrow")
        let view = UIImageView(image: image)
        return view
    }()
    
    private lazy var successButton: CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "success_icon"), for: .normal)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        
        return btn
    }()

    

    private lazy var paddigView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
}

//MARK: 함수 모음
extension SwipeOnboardingThirdViewController {
    
    //Ruyha 레벨링이 변경될 때 추가 반영되어야함
    @objc
    func pressNextButton() {
        self.delegate?.changeNextView()
    }
}

//MARK: 오토레이아웃
extension SwipeOnboardingThirdViewController {
    
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
        
        view.addSubview(successArrowImageView)
        successArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(view.snp.centerY).multipliedBy(0.93)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(OrrPadding.padding5.rawValue)
            $0.trailing.equalTo(view.snp.trailing).offset(-OrrPadding.padding3.rawValue)
            $0.height.equalTo(successArrowImageView.snp.width).multipliedBy(0.708)
        }
        
        view.addSubview(paddigView)
        paddigView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(mainImageView.snp.leading)
            $0.trailing.equalTo(mainImageView.snp.trailing)
        }
        
        paddigView.addSubview(successButton)
        successButton.snp.makeConstraints {
            $0.centerY.equalTo(paddigView.snp.centerY).multipliedBy(0.7)
            $0.trailing.equalTo(paddigView.snp.trailing)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }

    }
}

