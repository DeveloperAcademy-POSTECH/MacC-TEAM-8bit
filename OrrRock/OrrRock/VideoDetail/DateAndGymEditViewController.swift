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
    var selectGymName : String?
    var completioHandler : ((String,Date) -> (Void))?
    
    var visitedGymList: [VisitedClimbingGym] = []
    var filteredVisitedGymList: [VisitedClimbingGym] = []
    var maxTableViewCellCount: Int = 0

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
        label.backgroundColor = .orrGray100
        return label
    }()
    
    lazy var gymTextField : UnderlinedTextField = {
        let view = UnderlinedTextField()
        view.borderStyle = .none
        view.placeholder = "김대우 암벽교실"
        view.tintColor = .orrUPBlue
        view.font = UIFont.systemFont(ofSize: 22)
        view.addTarget(self, action: #selector(searchGymName(textField:)), for: .editingChanged)
        return view
    }()
    
    lazy var saveButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.addTarget(self, action: #selector(pressSaveButton), for: .touchUpInside)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    //MARK: date view 관련 components
    private lazy var datePickerLabel : UILabel = {
        let label = UILabel()
        label.text = Date().timeToString()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .orrGray500
        label.backgroundColor = .orrGray100
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
        datePicker.backgroundColor = .orrGray100
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    private lazy var nextButton : UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
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
    
    lazy var autocompleteTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(AutocompleteTableViewCell.classForCoder(), forCellReuseIdentifier: AutocompleteTableViewCell.identifier)
        return tableView
    }()
    
    lazy var tableViewHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 방문"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setUpTableViewData()
        setUpLayout()
        setData()
    }
    
    private func setUpLayout(){
        view.backgroundColor = .orrGray100
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
            $0.top.equalTo(dateContentView.snp.top).offset(OrrPadding.padding5.rawValue)
        }
        
        dateContentView.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.centerX.equalTo(dateContentView)
            $0.top.equalTo(datePickerLabel.snp.bottom).offset(OrrPadding.padding5.rawValue)
            $0.leading.equalTo(dateContentView).offset(OrrPadding.padding3.rawValue)
            $0.trailing.equalTo(dateContentView).offset(-OrrPadding.padding3.rawValue)
        }
        
        dateContentView.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(dateContentView)
            $0.bottom.equalTo(dateContentView).offset(-34)
            $0.leading.equalTo(dateContentView).offset(OrrPadding.padding3.rawValue)
            $0.trailing.equalTo(dateContentView).offset(-OrrPadding.padding3.rawValue)
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
            $0.top.equalTo(dateContentView.snp.top).offset(OrrPadding.padding5.rawValue)
        }
        
        gymContentView.addSubview(gymTextField)
        gymTextField.snp.makeConstraints{
            $0.centerX.equalTo(gymContentView)
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(OrrPadding.padding3.rawValue)
            $0.leading.equalTo(gymContentView).offset(OrrPadding.padding6.rawValue)
            $0.trailing.equalTo(gymContentView).offset(-OrrPadding.padding6.rawValue)
        }
        
        gymContentView.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
        
        gymContentView.addSubview(autocompleteTableView)
        autocompleteTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top)
            $0.height.equalTo(50 * min(maxTableViewCellCount, filteredVisitedGymList.count))
        }
        
        gymContentView.addSubview(tableViewHeaderLabel)
        tableViewHeaderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(OrrPadding.padding3.rawValue)
            $0.trailing.equalToSuperview().offset(OrrPadding.padding3.rawValue)
            $0.bottom.equalTo(autocompleteTableView.snp.top).offset(-OrrPadding.padding3.rawValue)
        }
    }
    
    private func setUpDelegate(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [.large()]
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
    }
    
    private func setData(){
        datePicker.date = videoInformation.gymVisitDate
        gymTextField.text = videoInformation.gymName
        gymTextField.placeholder = videoInformation.gymName
        datePickerLabel.text = videoInformation.gymVisitDate.timeToString()
        selectDate = videoInformation.gymVisitDate
        selectGymName = videoInformation.gymName
    }
    
    // DataManager에게서 데이터를 새로 받아올 때 사용하는 메서드
    // CoreData와 Repository 단에서 데이터 변화가 발생하는 경우에 본 메서드를 호출해 데이터를 동기화
    func setUpTableViewData() {
        visitedGymList = DataManager.shared.repository.visitedClimbingGyms
        filteredVisitedGymList = visitedGymList
        
        // 기기 대응한 테이블뷰셀의 개수
        // SE 사이즈 - 2개 / 13 사이즈 - 3개 / max 사이즈 - 4개
        maxTableViewCellCount = 1 + Int((UIScreen.main.bounds.height - 500) / 140)
    }
    
    // 자동완성 헤더 레이블의 텍스트를 수정
    func setTableViewHeaderLabel(text: String) {
        tableViewHeaderLabel.text = text
    }
    
    // 자동완성 테이블 뷰의 데이터 개수의 변화에 따른 테이블뷰의 레이아웃의 변화가 필요한 경우에 본 함수를 호출
    func resetAutocompleteTableView() {
        autocompleteTableView.reloadData()
        
        autocompleteTableView.snp.removeConstraints()
        autocompleteTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
            $0.height.equalTo(50 * min(maxTableViewCellCount, filteredVisitedGymList.count))
        }
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
        selectDate = datePicker.date
        UIView.animate(withDuration: 0.5) {
            self.dateContentView.alpha = 0.0
            self.gymContentView.alpha = 1.0
            self.gymTextField.becomeFirstResponder()
            self.titleLabel.text = "위치 편집"
        }
    }
    
    // 자동완성을 위한 테이블 내 클라이밍장 명 검색
    @objc
    final func searchGymName(textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            filteredVisitedGymList = visitedGymList
            setTableViewHeaderLabel(text: "최근 방문")
        } else {
            filteredVisitedGymList = visitedGymList.filter { $0.name.contains(textField.text!) }
            setTableViewHeaderLabel(text: filteredVisitedGymList.isEmpty ? "" : "이곳을 방문하셨나요?")
        }
        
        resetAutocompleteTableView()
    }
    
    @objc
    func pressSaveButton() {
        if gymTextField.text == "" {
            DataManager.shared.updateDateAndGymData(videoInformation: videoInformation, gymVisitDate: selectDate!, gymName: videoInformation.gymName)
            completioHandler?(videoInformation.gymName,selectDate!)
        } else {
            DataManager.shared.updateDateAndGymData(videoInformation: videoInformation, gymVisitDate: selectDate!, gymName: gymTextField.text!)
            completioHandler?(gymTextField.text!,selectDate!)
        }
        self.dismiss(animated: true)
    }
    
    @objc func didCancelButtonClicked(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
}

