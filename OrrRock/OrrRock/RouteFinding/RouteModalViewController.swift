//
//  RouteModalViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/26.
//

import UIKit

class RouteModalViewController: UIViewController {
    
    var isFoldering = true
    var delegate : RouteModalDelegate?
    private var buttonHeight = 56
    private var buttonSideOffset = 6.5
    private var buttonTopOffset = 58
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = isFoldering ? "도전에 성공했나요?" : "삭제하시겠어요?"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .orrGray700
        label.textAlignment = .center
        return label
    }()
    
    private lazy var leftReluctantButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(isFoldering ? "도전 중" : "취소", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .orrGray300
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: isFoldering ? #selector(folderingToChallenge): #selector(cancel), for: .touchUpInside)
        return btn
    }()
    
    private lazy var rightPreferButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.setTitle(isFoldering ? "도전 성공" : "삭제", for: .normal)
        btn.backgroundColor = isFoldering ? .orrUPBlue : .orrFail
        btn.addTarget(self, action: isFoldering ? #selector(folderingToSuccess) : #selector(deleteSelects), for: .touchUpInside)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    private func setUpLayout(){
        view.backgroundColor = .orrWhite
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.trailing.leading.equalToSuperview().inset(64)
        }
        view.addSubview(leftReluctantButton)
        leftReluctantButton.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(titleLabel.snp.bottom).offset(buttonTopOffset)
            $0.trailing.equalTo(view.snp.centerX).offset(-buttonSideOffset)
            $0.height.equalTo(buttonHeight)
        }
        
        view.addSubview(rightPreferButton)
        rightPreferButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(buttonTopOffset)
            $0.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.leading.equalTo(view.snp.centerX).offset(buttonSideOffset)
            $0.height.equalTo(buttonHeight)
        }
    }
    
    @objc private func cancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func deleteSelects() {
        self.dismiss(animated: true)
        delegate?.delete()
    }
    
    @objc private func folderingToChallenge() {
        self.dismiss(animated: true)
        delegate?.folderingToChallenge()
    }
    
    @objc private func folderingToSuccess() {
        self.dismiss(animated: true)
        delegate?.folderingToSuccess()
    }
}

