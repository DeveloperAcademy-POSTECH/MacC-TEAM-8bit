//
//  LevelAndPFEditViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/25.
//

import UIKit

class LevelAndPFEditViewController: UIViewController ,UISheetPresentationControllerDelegate {

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
                     picker.backgroundColor = .white
                     picker.delegate = self
                     picker.dataSource = self
                     return picker
           
           
             
                 }()
   출처: https://calmone.tistory.com/entry/iOS-UIKit-in-Swift-4-UIPickerView-사용하기-Select-value-with-UIPickerView [투데잇 (Today IT):티스토리]
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
            $0.top.equalTo(levelContentView.snp.top).offset(orrPadding.padding5.rawValue)
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
