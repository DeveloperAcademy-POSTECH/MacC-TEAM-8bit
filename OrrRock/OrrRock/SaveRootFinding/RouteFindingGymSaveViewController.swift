//
//  RouteFindingGymSaveViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/28.
//

import PhotosUI
import UIKit

import SnapKit

class RouteFindingGymSaveViewController: UIViewController {
    
    var routeDataDraft: RouteDataDraft
    var backgroundImage: UIImage
    
    var gymVisitDate : Date?
    var visitedGymList: [VisitedClimbingGym] = []
    var filteredVisitedGymList: [VisitedClimbingGym] = []
    var maxTableViewCellCount: Int = 0
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        button.tintColor = .white
        button.addAction(UIAction { _ in
            self.goBackAction()
        }, for: .touchUpInside)
        
        return button
    }()
    
    let gymNameLabel : UILabel = {
        let label = UILabel()
        label.text = "방문한 클라이밍장을 입력해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .orrBlack
        label.backgroundColor = .orrWhite
        return label
    }()
    
    let gymTextField : UnderlinedTextField = {
        let view = UnderlinedTextField()
        view.borderStyle = .none
        view.placeholder = "클라이밍장을 입력해주세요"
        view.tintColor = .orrUPBlue
        view.font = UIFont.systemFont(ofSize: 22)
        view.addTarget(self, action: #selector(toggleNextButton(textField:)), for: .editingChanged)
        view.addTarget(self, action: #selector(searchGymName(textField:)), for: .editingChanged)
        return view
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.orrUPBlue!, for: .normal)
        button.setBackgroundColor(.orrGray300!, for: .disabled)
        button.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        return button
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
        label.text = ""
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    init(routeDataDraft: RouteDataDraft, backgroundImage: UIImage) {
        self.routeDataDraft = routeDataDraft
        self.backgroundImage = backgroundImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    //MARK: 생명주기 함수 모음
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orrWhite
        overrideUserInterfaceStyle = .dark
        self.navigationController?.setExpansionBackbuttonArea()

        setUpData()
        setUpLayout()
        setUITableViewDelegate()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gymTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
}

//MARK: 함수모음
extension RouteFindingGymSaveViewController {
    
    //텍스트 필드의 내용물에 따라 버튼을 활성화 비활성화 시킴
    @objc
    final private func toggleNextButton(textField: UITextField) {
        nextButton.isEnabled = !(textField.text!.isEmpty)
    }
    
    // 자동완성을 위한 테이블 내 클라이밍장 명 검색
    @objc
    final func searchGymName(textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            filteredVisitedGymList = visitedGymList
            setTableViewHeaderLabel(text: filteredVisitedGymList.isEmpty ? "" : "최근 방문")
        } else {
            filteredVisitedGymList = visitedGymList.filter { $0.name.contains(textField.text!) }
            setTableViewHeaderLabel(text: filteredVisitedGymList.isEmpty ? "" : "이곳을 방문하셨나요?")
        }
        
        resetAutocompleteTableView()
    }
    
    @objc final func pressNextButton() {
        // 자동완성에 클라이밍장명 데이터 업데이트
        let target = visitedGymList.filter({ $0.name == gymTextField.text! })
        if target.isEmpty {
            // 만약 클라이밍장 명이 데이터에 포함되어 있지 않으면 추가하기
            DataManager.shared.createVisitedClimbingGym(gymName: gymTextField.text!)
        } else {
            // 만약 클라이밍장 명이 데이터에 이미 포함되어 있다면, 최근 방문으로 날짜 변경하기
            let index = visitedGymList.firstIndex(of: target[0])
            DataManager.shared.updateVisitedClimbingGym(updateTarget: visitedGymList[index!])
        }
        
        routeDataDraft.updateGymName(gymName: gymTextField.text!)
        
        let routeFindingLevelSaveViewController = RouteFindingLevelSaveViewController(routeDataDraft: routeDataDraft, backgroundImage: backgroundImage)
        navigationController?.pushViewController(routeFindingLevelSaveViewController, animated: true)
    }
    
    
    final private func authSettingOpen(alertType: AuthSettingAlert) {
        let message = alertType.rawValue
        let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .default) { (UIAlertAction) in
            print("\(String(describing: UIAlertAction.title)) 클릭")
        }
        let confirm = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setUITableViewDelegate() {
        autocompleteTableView.dataSource = self
        autocompleteTableView.delegate = self
    }
    
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // DataManager에게서 데이터를 새로 받아올 때 사용하는 메서드
    // CoreData와 Repository 단에서 데이터 변화가 발생하는 경우에 본 메서드를 호출해 데이터를 동기화
    func setUpData() {
        visitedGymList = DataManager.shared.repository.visitedClimbingGyms
        filteredVisitedGymList = visitedGymList
        
        setTableViewHeaderLabel(text: filteredVisitedGymList.isEmpty ? "" : "최근 방문")
        // 기기 대응한 테이블뷰셀의 개수
        // SE 사이즈 - 2개 / 13 사이즈 - 3개 / max 사이즈 - 4개
        maxTableViewCellCount = 1 + Int((UIScreen.main.bounds.height - 500) / 140)
    }
    
    // 자동완성 헤더 레이블의 텍스트를 수정
    func setTableViewHeaderLabel(text: String) {
        tableViewHeaderLabel.text = text
    }
}

//MARK: 오토레이아웃 설정 영역
extension RouteFindingGymSaveViewController {
    
    func setUpLayout() {
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        view.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(exitButton).offset(OrrPd.pd72.rawValue)
        }
        
        view.addSubview(gymTextField)
        gymTextField.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(OrrPd.pd40.rawValue)
            $0.horizontalEdges.equalTo(view).inset(OrrPd.pd16.rawValue)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }
        
        view.addSubview(autocompleteTableView)
        autocompleteTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
            $0.height.equalTo(50 * min(maxTableViewCellCount, filteredVisitedGymList.count))
        }
        
        view.addSubview(tableViewHeaderLabel)
        tableViewHeaderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(OrrPd.pd16.rawValue)
            $0.trailing.equalToSuperview().offset(OrrPd.pd16.rawValue)
            $0.bottom.equalTo(autocompleteTableView.snp.top).offset(-OrrPd.pd16.rawValue)
        }
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
