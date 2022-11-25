//
//  RouteModalViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/26.
//

import UIKit

class RouteModalViewController: UIViewController {

    var isFoldering = true
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = isFoldering ? "선택하신 루트파인딩을 성공하셨나요?" : "선택하신 루트 파인딩을 삭제하시겠어요?"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .orrGray700
        return label
    }()
    
    private lazy var leftReluctantButton : UIButton = {
        let btn = UIButton()
        btn.setTitle(isFoldering ? "도전 중" : "취소", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .orrGray300
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return btn
    }()
    
    private lazy var rightPreferButton : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.setTitle(isFoldering ? "도전 성공" : "삭제", for: .normal)
        btn.backgroundColor = isFoldering ? .orrUPBlue : .orrFail
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        // Do any additional setup after loading the view.
    }

    func setUpLayout(){
        view.backgroundColor = .orrWhite
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.trailing.leading.equalToSuperview().inset(64)
        }
        view.addSubview(leftReluctantButton)
        leftReluctantButton.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(titleLabel.snp.bottom).offset(58)
            $0.trailing.equalTo(view.snp.centerX).offset(-6.5)
            $0.height.equalTo(56)
        }
        
        view.addSubview(rightPreferButton)
        rightPreferButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(58)
            $0.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.leading.equalTo(view.snp.centerX).offset(6.5)
            $0.height.equalTo(56)
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    @objc func delete(){
        self.dismiss(animated: true)
    }
    
    @objc func folderingToChallenge(){
        self.dismiss(animated: true)
    }
    
    @objc func delete(){
        self.dismiss(animated: true)
    }
}
