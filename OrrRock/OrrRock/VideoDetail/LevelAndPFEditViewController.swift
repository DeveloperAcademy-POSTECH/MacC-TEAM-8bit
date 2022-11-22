//
//  LevelAndPFEditViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/25.
//

import UIKit

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
    
    private lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "문제 편집"
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
        label.text = "레벨을 선택해 주세요"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .orrBlack
        label.backgroundColor = .orrWhite
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 180.0)
        picker.backgroundColor = .orrWhite
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var successLabel : UILabel = {
        let label = UILabel()
        label.text = "완등 여부를 설정해주세요"
        label.textColor = .orrBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .orrWhite
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
        self.pickerView.delegate?.pickerView?(self.pickerView, didSelectRow: pickerSelectValue, inComponent: 0)
        self.pickerView.selectRow(pickerSelectValue, inComponent: 0, animated: true)
        // Do any additional setup after loading the view.
    }
}

extension LevelAndPFEditViewController {
    
    private func setUpLayout(){
        view.backgroundColor = .orrWhite
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
            $0.top.equalTo(levelContentView.snp.top).offset(OrrPd.pd40.rawValue)
        }
        
        levelContentView.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.leading.equalTo(levelContentView).offset(47)
            $0.trailing.equalTo(levelContentView).offset(-47)
            $0.top.equalTo(LevelLabel.snp.bottom).offset(OrrPd.pd24.rawValue)
        }
        
        levelContentView.addSubview(successLabel)
        successLabel.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(OrrPd.pd72.rawValue)
            $0.centerX.equalToSuperview()
        }
        
        levelContentView.addSubview(successCheckButton)
        successCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(successLabel.snp.bottom).offset(61.5)
            $0.centerX.equalTo(LevelLabel.snp.centerX).offset(52)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        levelContentView.addSubview(failCheckButton)
        failCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(successLabel.snp.bottom).offset(61.5)
            $0.centerX.equalTo(LevelLabel.snp.centerX).offset(-52)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        levelContentView.addSubview(saveButton)
        saveButton.snp.makeConstraints{
            $0.centerX.equalTo(levelContentView)
            $0.bottom.equalTo(levelContentView).offset(-34)
            $0.leading.equalTo(levelContentView).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(levelContentView).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
        levelContentView.addSubview(indicateLabel)
        indicateLabel.snp.makeConstraints {
            $0.top.equalTo(successLabel).offset(145)
            $0.centerX.equalTo(levelContentView)
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
        pickerView.selectRow(Int(videoInformation.problemLevel), inComponent: 0, animated: true)
    }
}

extension LevelAndPFEditViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectLevel = row - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levelValues[row] == -1 ? "선택안함" : "V\(levelValues[row])"
    }
}
