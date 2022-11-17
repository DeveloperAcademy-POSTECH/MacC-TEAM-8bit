//
//  SwipeOnboardingFirstViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/16.
//

import UIKit
import SnapKit

class SwipeOnboardingFirstViewController: UIViewController {
    
    var delegate: SwipeOnboardingViewControllerDelegate?
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        btn.setTitle("방법 살펴보기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        return btn
    }()
    
    private lazy var backgroundRightTiltView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(hex: "EEEEEE")
        //        view.backgroundColor =  .black
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backgroundLeftTiltView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray1
        //        view.backgroundColor =  .purple
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var backgroundCenterView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray3
        //        view.backgroundColor =  .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    
    private lazy var RTview: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = .cyan
        setUpLayout()
        // Do any additional setup after loading the view.
    }
    
    func ppap1(){
        view.backgroundColor = .red
    }
    func ppap2(){
        view.backgroundColor = .green
    }
    func ppap3(){
        view.backgroundColor = .blue
    }
    @objc
    func pressNextButton() {
        self.delegate?.changeNextView()
        print("ppap: ")
    }
}

extension SwipeOnboardingFirstViewController{
    private func setUpLayout(){

        view.addSubview(RTview)
        RTview.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.height.equalTo(view.snp.height)
            $0.width.equalTo(view.snp.width)
            RTview.setUpLayout()
        }

        view.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPadding.padding3.rawValue)
            $0.leading.equalTo(view).offset(OrrPadding.padding3.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPadding.padding3.rawValue)
            $0.height.equalTo(56)
        }
        
    }
}

