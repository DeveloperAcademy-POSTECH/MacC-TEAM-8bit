//
//  DateEditViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/21.
//

import Foundation

import UIKit
import SnapKit

final class DateEditViewController: UIViewController , UISheetPresentationControllerDelegate{
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    var videoInformation : VideoInformation!
    var selectDate : Date?
    var selectGymName : String?
    var completioHandler : ((Date) -> (Void))?
    
    var visitedGymList: [VisitedClimbingGym] = []
    var filteredVisitedGymList: [VisitedClimbingGym] = []
    var maxTableViewCellCount: Int = 0

    // MARK: gym view compenents
    private lazy var gymContentView : UIView = {
        let view = UIView()
        view.alpha = 0.0
        return view
    }()
    
    //MARK: date view 관련 components
    private lazy var datePickerLabel : UILabel = {
        let label = UILabel()
        label.text = "방문한 날짜를 선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .orrBlack
        label.backgroundColor = .orrWhite
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
        datePicker.backgroundColor = .orrWhite
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    lazy var saveButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(pressSaveButton), for: .touchUpInside)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    private lazy var dateContentView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dateTopView : UIView = {
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
        setData()
    }
    
    private func setUpLayout(){
        view.backgroundColor = .orrWhite
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
            $0.leading.equalTo(dateContentView).offset(15.5)
            $0.top.equalTo(dateContentView.snp.top).offset(OrrPd.pd72.rawValue)
        }
        
        dateContentView.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.centerX.equalTo(dateContentView)
            $0.top.equalTo(datePickerLabel.snp.bottom).offset(OrrPd.pd24.rawValue)
            $0.leading.equalTo(dateContentView).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(dateContentView).offset(-OrrPd.pd16.rawValue)
        }
        
        dateContentView.addSubview(saveButton)
        saveButton.snp.makeConstraints{
            $0.centerX.equalTo(dateContentView)
            $0.bottom.equalTo(dateContentView).offset(-34)
            $0.leading.equalTo(dateContentView).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(dateContentView).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
    }
    
    private func setUpDelegate(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [.large()]
    }
    
    private func setData(){
        datePicker.date = videoInformation.gymVisitDate
        selectDate = videoInformation.gymVisitDate
    }
}

extension DateEditViewController {
    
    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        saveButton.isEnabled = true
    }
    
    @objc
    func pressSaveButton() {
        DataManager.shared.updateDateData(videoInformation: videoInformation, gymVisitDate: datePicker.date)
        completioHandler?(datePicker.date)
        self.dismiss(animated: true)
    }
    
    @objc
    func didCancelButtonClicked(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
}

