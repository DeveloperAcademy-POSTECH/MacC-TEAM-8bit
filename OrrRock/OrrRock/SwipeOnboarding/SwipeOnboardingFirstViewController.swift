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
