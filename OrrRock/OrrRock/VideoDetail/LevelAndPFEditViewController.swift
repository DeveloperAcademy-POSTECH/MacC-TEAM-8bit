//
//  LevelAndPFEditViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/25.
//

import UIKit
import SnapKit

class LevelAndPFEditViewController: UIViewController ,UISheetPresentationControllerDelegate {
    
    var isSuccess : Bool = false
    private let levelValues: [Int] = [-1,0,1,2,3,4,5,6,7,8,9]
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    var videoInformation : VideoInformation!
    var completioHandler : ((Bool,Int) -> (Void))?
    var selectSuccess : Bool?
    var selectLevel : Int?
    var pickerSelectValue = 0
    private let padding = 68

    private lazy var levelTopView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .orrGray100
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.left.equalToSuperview().inset(15)
        }
        return view
    }()
    
    lazy var cancelButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(didCancelButtonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var newLevelPickerView: NewLevelPickerView = {
        let view = NewLevelPickerView()
        view.pickerSelectValue = pickerSelectValue
        view.delegate = self
        view.backgroundColor = .orrGray050
        return view
    }()

    
    
    private lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "문제 편집"
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .orrBlack
        return title
    }()
    
    private lazy var paddingView : UIView = {
        let view = UIView()
        return view
    }()
    
    
    lazy var successLabel : UILabel = {
        let label = UILabel()
        label.text = "완등 여부를 설정해주세요"
        label.textColor = .orrBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        label.backgroundColor = .orrWhite
        label.textAlignment = .center

        return label
    }()
    
    private lazy var failCheckButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "fail_icon"), for: .normal)
        button.addTarget(self, action: #selector(didFailButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var successCheckButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "success_icon"), for: .normal)
        button.addTarget(self, action: #selector(didSuccessButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var indicateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .orrBlack
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var saveButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(pressSaveButton), for: .touchUpInside)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               saveButton.setBackgroundColor(.orrUPBlue!, for: .normal)
               saveButton.setBackgroundColor(.orrGray300!, for: .disabled)
           }
       }
    }
}

extension LevelAndPFEditViewController {
    
    private func setUpLayout(){
        view.backgroundColor = .orrGray050
        view.addSubview(levelTopView)
        levelTopView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalToSuperview()
        }
        
        view.addSubview(newLevelPickerView)
        newLevelPickerView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(110)
//            newLevelPickerView.backgroundColor = .red
        }
        
        view.addSubview(successLabel)
        successLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd16.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(paddingView)
        paddingView.snp.makeConstraints {
//            paddingView.backgroundColor = .yellow
            $0.leading.equalTo(view.snp.leading).offset(padding)
            $0.trailing.equalTo(view.snp.trailing).offset(-padding)
            $0.top.equalTo(successLabel.snp.bottom)
            $0.bottom.equalTo(saveButton.snp.top)
        }
        
        paddingView.addSubview(failCheckButton)
        failCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(paddingView.snp.centerY).multipliedBy(0.9)
            $0.leading.equalTo(paddingView.snp.leading).offset(padding / 2)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        paddingView.addSubview(successCheckButton)
        successCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(paddingView.snp.centerY).multipliedBy(0.9)
            $0.trailing.equalTo(paddingView.snp.trailing).offset(-padding / 2)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }

        paddingView.addSubview(indicateLabel)
        indicateLabel.snp.makeConstraints {
            $0.centerY.equalTo(paddingView.snp.centerY).multipliedBy(1.5)
            $0.centerX.equalTo(paddingView)
        }
        
    }
    
    @objc
    private func pressSaveButton(_ sender: UIButton) {
        DataManager.shared.updateLevelAndPF(videoInformation: videoInformation, problemLevel: selectLevel!, isSucceeded: isSuccess)
        completioHandler!(isSuccess,selectLevel!)
        self.dismiss(animated: true)
    }
    
    @objc func didCancelButtonClicked(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    @objc func didSuccessButtonClicked(_ sender: UIButton){
        isSuccess = true
        saveButton.isEnabled = true
        self.successCheckButton.snp.updateConstraints {
            $0.height.equalTo(100)
            $0.width.equalTo(100)
        }
        self.failCheckButton.snp.updateConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.successCheckButton.alpha = 1.0
            self.failCheckButton.alpha = 0.3
            self.successCheckButton.setImage(UIImage(named: "success_select"), for: .normal)
            self.failCheckButton.setImage(UIImage(named: "fail_icon"), for: .normal)
            self.indicateLabel.text = "이 문제는 완등했어요"
        }
        
    }
    
    @objc func didFailButtonClicked(_ sender: UIButton){
        isSuccess = false
        saveButton.isEnabled = true
        self.failCheckButton.snp.updateConstraints {
            $0.height.equalTo(100)
            $0.width.equalTo(100)
        }
        self.successCheckButton.snp.updateConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.failCheckButton.alpha = 1.0
            self.successCheckButton.alpha = 0.3
            self.failCheckButton.setImage(UIImage(named: "fail_select"), for: .normal)
            self.successCheckButton.setImage(UIImage(named: "success_icon"), for: .normal)
            self.indicateLabel.text = "이 문제는 완등하지 못했어요"
        }
    }
    
    private func setData(){
        isSuccess = videoInformation.isSucceeded
        selectLevel = Int(videoInformation.problemLevel)
    }
}

extension LevelAndPFEditViewController: NewLevelPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: Int) {
        //currentSelectedLevel = selectedLevel
        selectLevel = selectedLevel
    }
    
}
