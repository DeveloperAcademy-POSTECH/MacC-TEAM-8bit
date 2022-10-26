//
//  OnBoardingViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/26.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController , UISheetPresentationControllerDelegate{

    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.text = "오르락 시작하기"
        return label
    }()
    
    private lazy var subLabel1 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "클라이밍 발견하기"
        return label
    }()
    
    private lazy var subLabel2 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "날짜, 암장, 성공, 실패 및 즐겨찾는 항목의\n영상을 분류해 줍니다."
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subLabel3 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "요약 보기"
        return label
    }()
    
    private lazy var subLabel4 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "성장 그래프 및 성공 횟수를 보여줍니다."
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setUpLayout()
        // Do any additional setup after loading the view.
    }
    

    private func setUpDelegate(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [.large()]
    }
    
    private func setUpLayout(){
        view.backgroundColor = .orrWhite
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(81)
        }
        view.addSubview(subLabel1)
        subLabel1.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(41)
        }
        
        view.addSubview(subLabel2)
        subLabel2.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
        }
        
        view.addSubview(subLabel3)
        subLabel3.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(122)
        }
        
        view.addSubview(subLabel4)
        subLabel4.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(148)
        }
    }

}
