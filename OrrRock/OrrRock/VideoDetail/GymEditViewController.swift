//
//  DateAndGymEditViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/25.
//

import UIKit
import SnapKit

final class GymEditViewController: UIViewController , UISheetPresentationControllerDelegate{
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    var videoInformation : VideoInformation!
    var selectDate : Date?
    var selectGymName : String?
    var completioHandler : ((String) -> (Void))?
    
    var visitedGymList: [VisitedClimbingGym] = []
    var filteredVisitedGymList: [VisitedClimbingGym] = []
    var maxTableViewCellCount: Int = 0

    // MARK: gym view compenents
    private lazy var gymContentView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var gymTopView : UIView = {
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
    
    private lazy var gymNameLabel : UILabel = {
        let label = UILabel()
        label.text = "방문한 클라이밍장을 입력해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .orrBlack
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
    
    lazy var cancelButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(didCancelButtonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.text = "클라이밍장 편집"
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
        view.backgroundColor = .orrWhite
        self.navigationController?.isToolbarHidden = false
        
        view.addSubview(gymTopView)
        gymTopView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalToSuperview()
        }
        
        view.addSubview(gymContentView)
        gymContentView.snp.makeConstraints {
            $0.top.equalTo(gymTopView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        gymContentView.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.centerX.equalTo(gymContentView)
            $0.top.equalTo(gymContentView.snp.top).offset(OrrPd.pd72.rawValue)
        }
        
        gymContentView.addSubview(gymTextField)
        gymTextField.snp.makeConstraints{
            $0.centerX.equalTo(gymContentView)
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(OrrPd.pd36.rawValue)
            $0.horizontalEdges.equalTo(gymContentView).inset(OrrPd.pd16.rawValue)
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
            $0.leading.equalToSuperview().offset(OrrPd.pd16.rawValue)
            $0.trailing.equalToSuperview().offset(OrrPd.pd16.rawValue)
            $0.bottom.equalTo(autocompleteTableView.snp.top).offset(-OrrPd.pd16.rawValue)
        }
    }
    
    private func setUpDelegate(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [.large()]
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        
        gymTextField.becomeFirstResponder()
    }
    
    private func setData(){
        gymTextField.text = videoInformation.gymName
        gymTextField.placeholder = videoInformation.gymName
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
            $0.bottom.equalTo(saveButton.snp.top)
            $0.height.equalTo(50 * min(maxTableViewCellCount, filteredVisitedGymList.count))
        }
    }
}

extension GymEditViewController {
    
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
            DataManager.shared.updateGymData(videoInformation: videoInformation, gymName: videoInformation.gymName)
            completioHandler?(videoInformation.gymName)
        } else {
            DataManager.shared.updateGymData(videoInformation: videoInformation, gymName: gymTextField.text!)
            completioHandler?(gymTextField.text!)
        }
        self.dismiss(animated: true)
    }
    
    @objc
    func didCancelButtonClicked(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
}
