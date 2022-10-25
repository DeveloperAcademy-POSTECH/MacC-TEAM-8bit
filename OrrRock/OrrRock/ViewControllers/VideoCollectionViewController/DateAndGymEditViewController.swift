//
//  DateAndGymEditViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/25.
//

import UIKit
import SnapKit

final class DateAndGymEditViewController: UIViewController , UISheetPresentationControllerDelegate{
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    var videoInformation : VideoInformation!
    var selectDate : Date?
    var selecrGymName : String?
    
    // MARK: gym view compenents
    private lazy var gymContentView : UIView = {
        let view = UIView()
        view.alpha = 0.0
        return view
    }()
    
    private lazy var gymNameLabel : UILabel = {
        let label = UILabel()
        label.text = "해당 암장의 이름을 적어주세요"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .orrBlack
        label.backgroundColor = .orrGray1
        return label
    }()
    
    private lazy var gymTextField : UnderlinedTextField = {
        let view = UnderlinedTextField()
        view.borderStyle = .none
        view.placeholder = "김대우 암벽교실"
        view.tintColor = .orrUPBlue
        view.font = UIFont.systemFont(ofSize: 22)
        return view
    }()
    
    private lazy var saveButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.addTarget(self, action: #selector(pressSaveButton), for: .touchDown)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    //MARK: date view 관련 components
    
    private lazy var datePickerLabel : UILabel = {
        let label = UILabel()
        label.text = Date().timeToString()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .orrGray3
        label.backgroundColor = .orrGray1
        return label
    }()
    
    private lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.locale = Locale(identifier:"ko_KR")
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        datePicker.backgroundColor = .orrGray1
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    private lazy var nextButton : UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchDown)
        btn.setTitle("계속", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    private lazy var dateContentView : UIView = {
        let view = UIView()
        return view
    }()
    
    
    private lazy var dateTopView : UIView = {
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
    
    lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "날짜 편집"
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .black
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setUpLayout()
        // Do any additional setup after loading the view.
    }
    
    private func setUpLayout(){
        view.backgroundColor = .orrGray1
        self.navigationController?.isToolbarHidden = false
        
        view.addSubview(dateTopView)
        dateTopView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalToSuperview()
        }
        
        view.addSubview(dateContentView)
        dateContentView.snp.makeConstraints {
            $0.top.equalTo(dateTopView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        dateContentView.addSubview(datePickerLabel)
        datePickerLabel.snp.makeConstraints {
            $0.centerX.equalTo(dateContentView)
            $0.top.equalTo(dateContentView.snp.top).offset(orrPadding.padding5.rawValue)
        }
        
        dateContentView.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.centerX.equalTo(dateContentView)
            $0.top.equalTo(datePickerLabel.snp.bottom).offset(orrPadding.padding5.rawValue)
            $0.leading.equalTo(dateContentView).offset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(dateContentView).offset(-orrPadding.padding3.rawValue)
        }
        
        dateContentView.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(dateContentView)
            $0.bottom.equalTo(dateContentView).offset(-34)
            $0.leading.equalTo(dateContentView).offset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(dateContentView).offset(-orrPadding.padding3.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(gymContentView)
        gymContentView.snp.makeConstraints {
            $0.top.equalTo(dateTopView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        gymContentView.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.centerX.equalTo(dateContentView)
            $0.top.equalTo(dateContentView.snp.top).offset(orrPadding.padding5.rawValue)
        }
        
        gymContentView.addSubview(gymTextField)
        gymTextField.snp.makeConstraints{
            $0.centerX.equalTo(gymContentView)
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(orrPadding.padding7.rawValue)
            $0.leading.equalTo(gymContentView).offset(orrPadding.padding6.rawValue)
            $0.trailing.equalTo(gymContentView).offset(-orrPadding.padding6.rawValue)
        }
        
        gymContentView.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
    }
    
    private func setUpDelegate(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [.large()]
    }
}

extension DateAndGymEditViewController {
    
    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        datePickerLabel.text = sender.date.timeToString()
        datePickerLabel.textColor = .black
    }
    
    @objc
    private func pressNextButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.dateContentView.alpha = 0.0
            self.gymContentView.alpha = 1.0
            self.gymTextField.becomeFirstResponder()
            self.titleLabel.text = "위치 편집"
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
