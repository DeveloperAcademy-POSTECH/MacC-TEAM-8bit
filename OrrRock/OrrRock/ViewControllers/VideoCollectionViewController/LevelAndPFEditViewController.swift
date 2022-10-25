//
//  LevelAndPFEditViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/25.
//

import UIKit

class LevelAndPFEditViewController: UIViewController ,UISheetPresentationControllerDelegate {

    private let values: [String] = ["V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14"]
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }

    
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
    
    private lazy var successCheckButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 37.5
           button.clipsToBounds = true
        button.backgroundColor = .orrPass
        button.setTitle("성공", for: .normal)
        return button
    }()
    
    private lazy var failCheckButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 37.5
           button.clipsToBounds = true
        button.backgroundColor = .orrFail
        button.setTitle("실패", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            $0.top.equalTo(successLabel.snp.bottom).offset(orrPadding.padding5.rawValue)
            $0.leading.equalTo(levelContentView.snp.leading).offset(206)
            $0.width.equalTo(75)
            $0.height.equalTo(75)
        }
        
        levelContentView.addSubview(failCheckButton)
        failCheckButton.snp.makeConstraints {
            $0.top.equalTo(successLabel.snp.bottom).offset(orrPadding.padding5.rawValue)
            $0.leading.equalTo(levelContentView.snp.leading).offset(109)
            $0.width.equalTo(75)
            $0.height.equalTo(75)
        }
    }
    
    @objc
    private func pressSaveButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func didCancelButtonClicked(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
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
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        values[row]
    }
}
