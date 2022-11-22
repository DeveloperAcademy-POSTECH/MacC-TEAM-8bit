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

    // MARK: gym view compenents
    private lazy var gymContentView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var gymTopView : UIView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
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
            $0.top.equalTo(gymContentView.snp.top).offset(OrrPd.pd24.rawValue)
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
        
    }
    
    private func setUpDelegate(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [.large()]
        
    }
    
    private func setData(){
        gymTextField.text = videoInformation.gymName
        gymTextField.placeholder = videoInformation.gymName
        selectGymName = videoInformation.gymName
    }
   
}

extension GymEditViewController {
    
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
