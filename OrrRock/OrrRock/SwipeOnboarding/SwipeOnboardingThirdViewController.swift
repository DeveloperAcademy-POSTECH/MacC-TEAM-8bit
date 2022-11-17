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
    // 제스쳐를 추가하는코드
    let gesture = UIPanGestureRecognizer()
    let cornerRadius: CGFloat = 10
    
    private lazy var BackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let image = UIImage(named: "SwipeOnboardingImage3")
        let view = UIImageView(image: image)
        view.layer.borderWidth = 3
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.zPosition = 1
        view.isUserInteractionEnabled = true
        gesture.addTarget(self, action: #selector(self.handlerCard))
        view.addGestureRecognizer(gesture)
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
        btn.addTarget(self, action: #selector(didFailButton), for: .touchUpInside)
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
    
    @objc func handlerCard(_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view as? UIImageView {
            let point = gesture.translation(in: view)
            
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x > 0 {
                card.setVideoBackgroundViewBorderColor(color: .pass, alpha: rotationAngle * 10) //5
            } else {
                card.setVideoBackgroundViewBorderColor(color: .clear, alpha: 1.0) // -rotationAngle * 5
            }
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            if gesture.state == .ended {
                if card.center.x > self.view.bounds.width / 3 * 2 {
                    card.alpha = 0
                    self.delegate?.changeNextView()
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    card.center = self.BackgroundView.center
                    card.transform = .identity
                    card.setVideoBackgroundViewBorderColor(color: .clear, alpha: 1)
                    self.view.isUserInteractionEnabled = false
                } completion: {_ in
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @objc func didFailButton() {
        mainImageView.layer.borderColor = UIColor.orrPass?.cgColor
        UIView.animate(withDuration: 0.3, animations: { [self] in
            mainImageView.transform = CGAffineTransform(rotationAngle: 0.4)
            mainImageView.center = CGPoint(x: mainImageView.center.x + view.bounds.width, y: mainImageView.center.y + 30)
        }){ [self] _ in
            mainImageView.alpha = 0.0
            pressNextButton()
        }
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

extension UIImageView {
    func setVideoBackgroundViewBorderColor(color: VideoBackgroundViewBorderColor,alpha: CGFloat) {
        var r : CGFloat = 0.0
        var g : CGFloat = 0.0
        var b : CGFloat = 0.0
        
        switch color {
        case.pass :
            r = 48; g = 176; b = 199
        case .fail :
            r = 242; g = 52; b = 52
        case .clear :
            r = 255; g = 255; b = 255
        }
        self.layer.borderColor = UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha: alpha).cgColor
    }
}
