//
//  LevelAndPFEditViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/25.
//

import UIKit

class LevelAndPFEditViewController: UIViewController ,UISheetPresentationControllerDelegate {
    
    var isSuccess : Bool = false
    
    private let values: [Int] = [1,2,3,4,5,6,7,8,9]
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    var videoInformation : VideoInformation!
    var completioHandler : ((Bool,Int) -> (Void))?
    var selectSuccess : Bool?
    var selectLevel : Int?
    
    private lazy var levelTopView : UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        
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
    
    private lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "레벨 및 성공 여부 편집"
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .black
        return title
    }()
    
    private lazy var levelContentView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var LevelLabel : UILabel = {
        let label = UILabel()
        label.text = "해당 문제의 레벨을 선택해 주세요."
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .orrBlack
        label.backgroundColor = .orrGray1
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 180.0)
        picker.backgroundColor = .orrGray1
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var successLabel : UILabel = {
        let label = UILabel()
        label.textColor = .orrBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "성공 여부를 설정해주세요"
        return label
    }()
    
    private lazy var failCheckButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = isSuccess ? 30.5 : 37.5
        button.alpha = isSuccess ? 0.3 : 1.0
        button.clipsToBounds = true
        button.backgroundColor = .orrFail
        button.setTitle("실패", for: .normal)
        button.addTarget(self, action: #selector(didFailButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var successCheckButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = isSuccess ? 37.5 : 30.5
        button.alpha = isSuccess ? 1.0 : 0.3
        button.clipsToBounds = true
        button.backgroundColor = .orrPass
        button.setTitle("성공", for: .normal)
        button.addTarget(self, action: #selector(didSuccessButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var saveButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(pressSaveButton), for: .touchDown)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setData()
        // Do any additional setup after loading the view.
    }
    
    
}

extension LevelAndPFEditViewController {
    
    private func setUpLayout(){
        view.backgroundColor = .orrGray1
        view.addSubview(levelTopView)
        levelTopView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalToSuperview()
        }
        view.addSubview(levelContentView)
        levelContentView.snp.makeConstraints {
            $0.top.equalTo(levelTopView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        levelContentView.addSubview(LevelLabel)
        LevelLabel.snp.makeConstraints {
            $0.centerX.equalTo(levelContentView)
            $0.top.equalTo(levelContentView.snp.top).offset(orrPadding.padding6.rawValue)
        }
        
        levelContentView.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.width.equalTo(levelContentView)
            $0.leading.equalTo(levelContentView)
            $0.top.equalTo(LevelLabel.snp.bottom).offset(orrPadding.padding5.rawValue)
        }
        
        levelContentView.addSubview(successLabel)
        successLabel.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(orrPadding.padding7.rawValue)
            $0.centerX.equalToSuperview()
        }
        
        levelContentView.addSubview(successCheckButton)
        successCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(successLabel.snp.bottom).offset(61.5)
            $0.centerX.equalTo(LevelLabel.snp.centerX).offset(52)
            $0.width.equalTo(isSuccess ? 75 : 61)
            $0.height.equalTo(isSuccess ? 75 : 61)
        }
        
        levelContentView.addSubview(failCheckButton)
        failCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(successLabel.snp.bottom).offset(61.5)
            $0.centerX.equalTo(LevelLabel.snp.centerX).offset(-52)
            $0.width.equalTo(isSuccess ? 61 : 75)
            $0.height.equalTo(isSuccess ? 61 : 75)
        }
        
        levelContentView.addSubview(saveButton)
        saveButton.snp.makeConstraints{
            $0.centerX.equalTo(levelContentView)
            $0.bottom.equalTo(levelContentView).offset(-34)
            $0.leading.equalTo(levelContentView).offset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(levelContentView).offset(-orrPadding.padding3.rawValue)
            $0.height.equalTo(56)
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
        self.successCheckButton.snp.updateConstraints {
            $0.height.equalTo(75)
            $0.width.equalTo(75)
        }
        self.failCheckButton.snp.updateConstraints {
            $0.height.equalTo(61)
            $0.width.equalTo(61)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.successCheckButton.alpha = 1.0
            self.failCheckButton.alpha = 0.3
            self.successCheckButton.layer.cornerRadius = 37.5
            self.failCheckButton.layer.cornerRadius = 30.5
            
        }
        
    }
    
    @objc func didFailButtonClicked(_ sender: UIButton){
        isSuccess = false
        self.failCheckButton.snp.updateConstraints {
            $0.height.equalTo(75)
            $0.width.equalTo(75)
        }
        self.successCheckButton.snp.updateConstraints {
            $0.height.equalTo(61)
            $0.width.equalTo(61)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.failCheckButton.alpha = 1.0
            self.successCheckButton.alpha = 0.3
            self.failCheckButton.layer.cornerRadius = 37.5
            self.successCheckButton.layer.cornerRadius = 30.5
            
            
        }
        
        
    }
    
    private func setData(){
        isSuccess = videoInformation.isSucceeded
        selectLevel = Int(videoInformation.problemLevel)
        pickerView.selectRow(Int(videoInformation.problemLevel)-1, inComponent: 0, animated: true)
        if isSuccess{
            self.successCheckButton.snp.updateConstraints {
                $0.height.equalTo(75)
                $0.width.equalTo(75)
            }
            self.failCheckButton.snp.updateConstraints {
                $0.height.equalTo(61)
                $0.width.equalTo(61)
            }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.successCheckButton.alpha = 1.0
                self.failCheckButton.alpha = 0.3
                self.successCheckButton.layer.cornerRadius = 37.5
                self.failCheckButton.layer.cornerRadius = 30.5
                
            }
        }
    }
}

extension LevelAndPFEditViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        print(row)
        selectLevel = row + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "V\(values[row])"
    }
}
