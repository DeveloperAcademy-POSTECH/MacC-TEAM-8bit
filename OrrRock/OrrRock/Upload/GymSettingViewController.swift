//
//  GymSettingViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//

import PhotosUI
import UIKit

import SnapKit

class GymSettingViewController: UIViewController {
    
    var gymVisitDate : Date?
    var visitedGymList: [VisitedClimbingGym] = []
    var filteredVisitedGymList: [VisitedClimbingGym] = []
    var maxTableViewCellCount: Int = 0
    
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
        view.placeholder = "클라이밍장"
        view.tintColor = .orrUPBlue
        view.font = UIFont.systemFont(ofSize: 22)
        view.addTarget(self, action: #selector(toggleNextButton(textField:)), for: .editingChanged)
        view.addTarget(self, action: #selector(searchGymName(textField:)), for: .editingChanged)
        return view
    }()
    
   
    let nextButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        btn.setTitle("저장", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.orrGray400, for: .disabled)
        btn.isEnabled = false
        return btn
    }()
    
    lazy var autocompleteTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(AutocompleteTableViewCell.classForCoder(), forCellReuseIdentifier: AutocompleteTableViewCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: CGFloat(OrrPd.pd16.rawValue), bottom: 0, right: CGFloat(OrrPd.pd16.rawValue))
        return tableView
    }()
    
    lazy var tableViewHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    //MARK: 생명주기 함수 모음
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orrWhite
        self.navigationController?.setExpansionBackbuttonArea()

        setUpData()
        setUpLayout()
        setUITableViewDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gymTextField.becomeFirstResponder()

    }
    
    // MARK: Dark,Light 모드 전환 안될때 사용하세요.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               // ColorUtils.loadCGColorFromAsset returns cgcolor for color name
               nextButton.setBackgroundColor(.orrUPBlue!, for: .normal)
               nextButton.setBackgroundColor(.orrGray300!, for: .disabled)
           }
       }
    }
    
}

//MARK: 함수모음
extension GymSettingViewController {
    
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
    
    @objc
    final func pressNextButton() {
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
        
        // 영상 선택
        let photoLibrary =  PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = .all(of: [.videos,.not(.slomoVideos)])
        configuration.selectionLimit = 0
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.present(picker, animated: true, completion: nil)
                    self.view.endEditing(true)
                }
            case .limited:
                DispatchQueue.main.async {
                    self.present(picker, animated: true, completion: nil)
                    self.view.endEditing(true)
                }
            default:
                DispatchQueue.main.async {
                    self.authSettingOpen(alertType: .denied)
                }
            }
        }
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
extension GymSettingViewController {
    
    func setUpLayout() {
        view.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OrrPd.pd24.rawValue)
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
            $0.trailing.equalToSuperview().offset(-OrrPd.pd16.rawValue)
            $0.bottom.equalTo(autocompleteTableView.snp.top).offset(-OrrPd.pd16.rawValue)
        }
    }
        
    // 자동완성 테이블 뷰의 데이터 개수의 변화에 따른 테이블뷰의 레이아웃의 변화가 필요한 경우에 본 함수를 호출
    func resetAutocompleteTableView() {
        autocompleteTableView.reloadData()
        
        autocompleteTableView.snp.removeConstraints()
        autocompleteTableView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(nextButton.snp.top)
            $0.height.equalTo(50 * min(maxTableViewCellCount, filteredVisitedGymList.count))
        }
    }
}

extension GymSettingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var videoInfoArray : [VideoInfo] = []
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        
        //인디케이트를 소환합니다.
        CustomIndicator.startLoading()
        
        guard results.count != 0 else {
            //사용자가 영상을 선택 하지 않았을때 예외처리
            CustomIndicator.stopLoading()
            gymTextField.becomeFirstResponder()
            return
        }
        
        guard results.count == fetchResult.count else{
            // 사용자가 선택한 영상과 허용된 영상의 갯수가 다를때 발생하는 문구
            CustomIndicator.stopLoading()
            gymTextField.becomeFirstResponder()
            self.authSettingOpen(alertType: .limited)
            return
        }
        
        for i in 0..<fetchResult.count {
            let localIdentifier = fetchResult[i].localIdentifier
            videoInfoArray.append(VideoInfo(gymName: gymTextField.text!,
                                            gymVisitDate: gymVisitDate!,
                                            videoLocalIdentifier: localIdentifier,
                                            problemLevel: 0,
                                            isSucceeded: true))
        }
        
        CustomIndicator.stopLoading()
        let nextVC = LevelAndPFSettingViewController()
        nextVC.videoInfoArray = videoInfoArray
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
