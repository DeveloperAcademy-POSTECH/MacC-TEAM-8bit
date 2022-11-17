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
    
    private lazy var BackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "SwipeOnboardingImage2")
        let view = UIImageView(image: image)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
}

//MARK: 함수 모음
extension SwipeOnboardingSecondViewController {
    
    //Ruyha 레벨링이 변경될 때 추가 반영되어야함
    @objc
    func pressNextButton() {
        self.delegate?.changeNextView()
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

        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(view.snp.leading).offset(padding)
            $0.trailing.equalTo(view.snp.trailing).offset(-padding)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.641)
        }
    }
}

