//
//  LevelAndPFEditViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/25.
//

import UIKit
import SnapKit
import Then

class LevelAndPFEditViewController: UIViewController ,UISheetPresentationControllerDelegate {
    
    var isSuccess : Bool = false
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    var videoInformation : VideoInformation?
    var routeInformation: RouteInformation?
    
    var completionHandler : ((Bool,Int) -> (Void))?
    var selectLevel : Int?
    var pickerSelectValue = 0
    private let padding = 68
    
    private lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "문제 편집"
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .orrBlack
        return title
    }()
    
    lazy var cancelButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(didCancelButtonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var levelTopView : UIView = .init().then {
        $0.backgroundColor = .orrGray100
    }
    
    private lazy var newLevelPickerView: NewLevelPickerView = .init().then {
        $0.pickerSelectValue = pickerSelectValue
        $0.delegate = self
        $0.backgroundColor = .orrGray050
    }
    
    private lazy var paddingView: UIView = .init()
    
    lazy var successLabel : UILabel = {
        let label = UILabel()
        label.text = "완등 여부를 알려주세요"
        label.textColor = .orrBlack
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var failCheckButton : UIButton = .init().then {
        $0.clipsToBounds = true
        $0.setImage(UIImage(named: "fail_icon"), for: .normal)
        $0.addTarget(self, action: #selector(didFailButtonClicked), for: .touchUpInside)
    }
    
    private lazy var successCheckButton : UIButton = .init().then {
        $0.clipsToBounds = true
        $0.setImage(UIImage(named: "success_icon"), for: .normal)
        $0.addTarget(self, action: #selector(didSuccessButtonClicked), for: .touchUpInside)
    }
    
    private lazy var indicateLabel: UILabel = .init().then {
        $0.textColor = .orrBlack
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
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
        if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
            saveButton.setBackgroundColor(.orrUPBlue!, for: .normal)
            saveButton.setBackgroundColor(.orrGray300!, for: .disabled)
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
        
        levelTopView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        levelTopView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.left.equalToSuperview().inset(15)
        }
        
        view.addSubview(newLevelPickerView)
        newLevelPickerView.snp.makeConstraints {
            $0.top.equalTo(levelTopView.snp.bottom).offset(OrrPd.pd72.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        view.addSubview(successLabel)
        successLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
            $0.leading.equalTo(view.snp.leading).offset(padding)
            $0.trailing.equalTo(view.snp.trailing).offset(-padding)
            $0.top.equalTo(successLabel.snp.bottom)
            $0.height.equalTo(160)
        }
        
        paddingView.addSubview(failCheckButton)
        failCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-padding)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        paddingView.addSubview(successCheckButton)
        successCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(padding)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        view.addSubview(indicateLabel)
        indicateLabel.snp.makeConstraints {
            $0.top.equalTo(paddingView.snp.bottom)
            $0.centerX.equalTo(paddingView)
        }
        
    }
    
    @objc
    private func pressSaveButton(_ sender: UIButton) {
        if let videoInformation {
            DataManager.shared.updateLevelAndPF(videoInformation: videoInformation, problemLevel: selectLevel!, isSucceeded: isSuccess)
            completionHandler!(isSuccess,selectLevel!)
        }
        else if let routeInformation {
            completionHandler!(isSuccess,selectLevel!)
        }
        else {
            // 정상적으로 데이터가 들어오지 않음
            print("DateEditViewController Input Data Error")
        }
        
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
        if let videoInformation {
            isSuccess = videoInformation.isSucceeded
            selectLevel = Int(videoInformation.problemLevel)
        }
        else if let routeInformation {
            isSuccess = routeInformation.isChallengeComplete
            selectLevel = Int(routeInformation.problemLevel)
        }
        else {
            // 정상적으로 데이터가 들어오지 않음
            print("DateEditViewController Input Data Error")
        }
    }
}

extension LevelAndPFEditViewController: NewLevelPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: Int) {
        selectLevel = selectedLevel
    }
    
}
