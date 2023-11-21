//
//  RouteInfoView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/29.
//

import UIKit

import SnapKit
import Then

final class RouteInfoView: UIView {
    
    // MARK: Variables
    
    var routeInformation : RouteInformation
    var routeDataDraft: RouteDataDraft
    var routeDataManager: RouteDataManager
    
    private var routeInfoDate: String = ""
    private var routeInfoLevel: String = ""
    private var routeInfoLocation: String = ""
    private var routeInfoIsSucceeded: Bool = true
    
    // MARK: View Components
    
    private lazy var dateView: UIView = .init().then {
        $0.backgroundColor = .orrGray100
        $0.layer.cornerRadius = 10
    }
    
    private lazy var dateIcon: UIImageView = .init().then {
        $0.image = UIImage(systemName: "calendar")
        $0.tintColor = .orrGray900
    }
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .orrBlack
        label.text = routeInfoDate
        return label
    }()
    
    // 클라이밍장 관련 View
    private lazy var gymNameView: UIView = .init().then {
        $0.backgroundColor = .orrGray100
        $0.layer.cornerRadius = 10
    }
    
    private lazy var gymNameIcon: UIImageView = .init().then {
        $0.image = UIImage(named: "location icon")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .orrGray900
    }
    
    private lazy var gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .orrBlack
        label.text = routeInfoLocation
        return label
    }()
    
    // 레벨 관련 View
    private lazy var levelView: UIView = .init().then {
        $0.backgroundColor = .orrGray100
        $0.layer.cornerRadius = 10
    }
    
    private lazy var levelIcon: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        label.font = .systemRoundedFont(ofSize: 14, weight: .medium)
        label.textColor = .orrGray100
        label.text = routeInfoLevel
        label.textAlignment = .center
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        label.backgroundColor = .orrGray900
        return label
    }()
    
    private lazy var isSucceeded: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .orrBlack
        label.text = routeInfoIsSucceeded ? "성공" : "실패"
        return label
    }()
    
    private lazy var dateEditButton: UIButton = .init().then {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        $0.addTarget(self, action: #selector(dateEdit), for: .touchUpInside)
    }
    
    private lazy var gymNameEditButton: UIButton = .init().then {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        $0.addTarget(self, action: #selector(gymNameEdit), for: .touchUpInside)
    }
    
    private lazy var levelPFEditButton: UIButton = .init().then {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        $0.addTarget(self, action: #selector(levelPFEdit), for: .touchUpInside)
    }
    
    // MARK: Life Cycle Functions
    
    init(routeDataDraft: RouteDataDraft) {
        
        self.routeDataDraft = routeDataDraft
        self.routeDataManager = routeDataDraft.routeDataManager
        self.routeInformation = routeDataDraft.route!
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .orrWhite
        
        setUpLayout()
        setUpData(routeInformation: routeInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: @objc Functions
    
    @objc private func dateEdit() {
        // 날짜, 클라이밍장 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        
        let vc = DateEditViewController()
        vc.routeInformation = routeInformation
        
        vc.completionHandler = { [self] date in
            routeDataManager.updateRouteDataWrittenDate(to: date, of: routeInformation)
            self.dateLabel.text = date.timeToString()
        }
        viewController.present(vc, animated: true)
    }
    
    @objc private func gymNameEdit() {
        // 날짜, 클라이밍장 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        let vc = GymEditViewController()
        vc.routeInformation = routeInformation
        
        vc.completionHandler = { [self] gymName in
            routeDataManager.updateRouteGymName(to: gymName, of: routeInformation)
            self.gymNameLabel.text = gymName
        }
        viewController.present(vc, animated: true)
    }
    
    @objc private func levelPFEdit() {
        // 난이도, 성패여부 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        let vc = LevelAndPFEditViewController()
        vc.routeInformation = routeInformation
        vc.pickerSelectValue = Int(routeInformation.problemLevel)
        
        vc.completionHandler = { isSuccess, level in
            self.routeDataManager.updateRouteLevelAndStatus(statusTo: isSuccess, levelTo: level, of: self.routeInformation)
            self.levelIcon.text = level == -1 ? "V?" : "V\(level)"
            self.isSucceeded.text = isSuccess ? "성공" : "실패"
        }
        viewController.present(vc, animated: true)
    }
}

extension RouteInfoView {
    
    // MARK: Set Up Functions
    
    private func setUpLayout() {
        // 날짜 입력 뷰
        self.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(self.snp.top).offset(OrrPd.pd16.rawValue)
        }
        // 클라이밍장 이름 뷰
        self.addSubview(gymNameView)
        gymNameView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(dateView.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        // 문제 난이도 뷰
        self.addSubview(levelView)
        levelView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(gymNameView.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        // 날짜 입력 뷰 내 컴포넌트
        dateView.addSubview(dateIcon)
        dateIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(dateView.snp.leading).offset(28)
            $0.width.height.equalTo(24)
        }
        
        dateView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dateIcon.snp.trailing).offset(OrrPd.pd8.rawValue)
        }
        
        // 클라이밍장 정보 뷰 내 컴포넌트
        gymNameView.addSubview(gymNameIcon)
        gymNameIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(gymNameView.snp.leading).offset(28)
            $0.width.height.equalTo(34)
        }
        
        gymNameView.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dateLabel.snp.leading)
        }
        
        // 문제 난이도 뷰 내 컴포넌트
        levelView.addSubview(levelIcon)
        levelIcon.snp.makeConstraints {
            $0.width.height.equalTo(26)
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(levelView.snp.leading).offset(28)
        }
        
        levelView.addSubview(isSucceeded)
        isSucceeded.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dateLabel.snp.leading)
        }
        
        // 날짜 편집 버튼
        dateView.addSubview(dateEditButton)
        dateEditButton.snp.makeConstraints {
            $0.centerY.equalTo(dateView.snp.centerY)
            $0.trailing.equalTo(dateView.snp.trailing).inset(OrrPd.pd20.rawValue)
        }
        
        gymNameView.addSubview(gymNameEditButton)
        gymNameEditButton.snp.makeConstraints {
            $0.centerY.equalTo(gymNameView.snp.centerY)
            $0.trailing.equalTo(gymNameView.snp.trailing).inset(OrrPd.pd20.rawValue)
        }
        
        // 난이도, 성패여부 편집 버튼
        levelView.addSubview(levelPFEditButton)
        levelPFEditButton.snp.makeConstraints {
            $0.centerY.equalTo(levelView.snp.centerY)
            $0.trailing.equalTo(levelView.snp.trailing).inset(OrrPd.pd20.rawValue)
        }
    }
    
    private func setUpData(routeInformation: RouteInformation) {
        dateLabel.text = routeInformation.dataWrittenDate.timeToString()
        levelIcon.text = routeInformation.problemLevel == -1 ? "V?" : "V\(routeInformation.problemLevel)"
        isSucceeded.text = routeInformation.isChallengeComplete ? "성공" : "실패"
        gymNameLabel.text = routeInformation.gymName
    }
}
