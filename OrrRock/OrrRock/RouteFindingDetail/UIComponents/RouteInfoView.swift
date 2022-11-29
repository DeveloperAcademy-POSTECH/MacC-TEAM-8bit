//
//  RouteInfoView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/29.
//

import UIKit

final class RouteInfoView: UIView {
    
    // MARK: Variables
    
//    private var routeInformation : RouteInformation
    private var routeInformation : RouteInformation?
    var routeDataManager: RouteDataManager?
    
    private var routeInfoDate: String = ""
    private var routeInfoLevel: String = ""
    private var routeInfoLocation: String = ""
    private var routeInfoIsSucceeded: Bool = true
    
    // MARK: View Components
    
    private lazy var dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray100
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var dateIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "calendar")
        view.tintColor = .orrGray900
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .orrBlack
        label.text = routeInfoDate
        return label
    }()
    
    // 클라이밍장 관련 View
    private lazy var gymNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray100
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var gymNameIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "location icon")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .orrGray900
        return view
    }()
    
    private lazy var gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .orrBlack
        label.text = routeInfoLocation
        return label
    }()
    
    // 레벨 관련 View
    private lazy var levelView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray100
        view.layer.cornerRadius = 10
        return view
    }()
    
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
    
    private lazy var dateEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(dateEdit), for: .touchUpInside)
        return button
    }()
    
    private lazy var gymNameEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(gymNameEdit), for: .touchUpInside)
        return button
    }()
    
    private lazy var levelPFEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
        button.addTarget(self, action: #selector(levelPFEdit), for: .touchUpInside)
        return button
    }()
    
    @objc private func dateEdit() {
        // 날짜, 클라이밍장 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        
        let vc = DateEditViewController()
        vc.routeInformation = routeInformation
        
        vc.completionHandler = { [self] date in
            routeDataManager?.updateRouteDataWrittenDate(to: date, of: routeInformation!)
            self.dateLabel.text = date.timeToString()
        }
        viewController.present(vc, animated: true)
    }
    
    @objc private func gymNameEdit() {
        // 날짜, 클라이밍장 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        let vc = GymEditViewController()
        vc.completionHandler = { [self] gymName in
            routeDataManager?.updateRouteGymName(to: gymName, of: routeInformation!)
            self.gymNameLabel.text = gymName
        }
        viewController.present(vc, animated: true)
    }
    
    @objc private func levelPFEdit() {
        // 난이도, 성패여부 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        let vc = LevelAndPFEditViewController()
//        vc.videoInformation = videoInformation
//        vc.pickerSelectValue = Int(videoInformation!.problemLevel)
        vc.completionHandler = { isSuccess, level in
            self.routeDataManager?.updateRouteLevelAndStatus(statusTo: isSuccess, levelTo: level, of: self.routeInformation!)
            self.levelIcon.text = level == -1 ? "V?" : "V\(level)"
            self.isSucceeded.text = isSuccess ? "성공" : "실패"
        }
        viewController.present(vc, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orrWhite
//        setUpLayout()
    }
    
    convenience init(frame: CGRect, routeInfo : RouteInformation, routeDataManager: RouteDataManager) {
        self.init(frame: frame)
        
        self.routeInformation = routeInfo
        self.routeDataManager = routeDataManager
//        refreshData(videoInfo: videoInfo)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

