//
//  VideoInfoView.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/23.
//

import UIKit

final class VideoInfoView: UIView {
    
    private var videoDate: String = ""
    private var videoLevel: String = ""
    private var videoLocation: String = ""
    private var videoIsSucceeded: Bool = true
    private var videoInformation : VideoInformation?
    
    lazy var feedbackTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .orrWhite
        view.font = .systemFont(ofSize: 17.0, weight: .semibold)
        view.keyboardType = .default
        view.returnKeyType = UIReturnKeyType.done
        return view
    }()
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // 날짜 관련 View
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
        label.text = videoDate
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
        label.text = videoLocation
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
        label.text = videoLevel
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
        label.text = videoIsSucceeded ? "성공" : "실패"
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
        vc.videoInformation = videoInformation
        vc.completioHandler = { [self] date in
            self.dateLabel.text = date.timeToString()
        }
        viewController.present(vc, animated: true)
    }
    
    @objc private func gymNameEdit() {
        // 날짜, 클라이밍장 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        let vc = GymEditViewController()
        vc.videoInformation = videoInformation
        vc.completioHandler = { [self] gymName in
            self.gymNameLabel.text = gymName
        }
        viewController.present(vc, animated: true)
    }
    
    @objc private func levelPFEdit() {
        // 난이도, 성패여부 편집 뷰 네비게이션
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        let vc = LevelAndPFEditViewController()
        vc.videoInformation = videoInformation
        vc.pickerSelectValue = Int(videoInformation!.problemLevel)
        vc.completioHandler = { isSuccess, level in
            
            self.levelIcon.text = level == -1 ? "V?" : "V\(level)"
            
            self.isSucceeded.text = isSuccess ? "성공" : "실패"
            
        }
        viewController.present(vc, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orrWhite
        setUpLayout()
    }
    
    convenience init(frame: CGRect, videoInfo : VideoInformation) {
        self.init(frame: frame)
        refreshData(videoInfo: videoInfo)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoInfoView: UITextViewDelegate {
    // 텍스트뷰가 비어있을 때 플레이스 홀더 띄워주는 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .placeholderText else { return }
        textView.textColor = .orrBlack
        textView.text = nil
    }
    
    // 다른 작업을 할 때 텍스트뷰가 비어있으면 플레이스 홀더 띄워주는 메서드
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "피드백 입력"
            textView.textColor = .placeholderText
        }
    }
}

extension VideoInfoView{
    func refreshData(videoInfo : VideoInformation){
        self.videoInformation = videoInfo
        dateLabel.text = videoInformation?.gymVisitDate.timeToString()
        levelIcon.text = videoInformation?.problemLevel == -1 ? "V?" : "V\(videoInformation?.problemLevel ?? -3)"
        isSucceeded.text = videoInformation!.isSucceeded ? "성공" : "실패"
        gymNameLabel.text = videoInformation?.gymName
        feedbackTextView.text = videoInformation?.feedback
        feedbackTextView.delegate = self  // 플레이스 홀더를 위한 델리게이트
        feedbackTextView.textColor = feedbackTextView.text.isEmpty || feedbackTextView.text == nil ? .placeholderText : .orrBlack
    }
}

extension VideoInfoView {
    @objc private func setUpLayout() {
        // textView
        self.addSubview(feedbackTextView)
        feedbackTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(self.snp.top).offset(OrrPd.pd16.rawValue)
            $0.height.equalTo(110)
        }
        // 날짜 입력 뷰
        self.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(feedbackTextView.snp.bottom).offset(OrrPd.pd8.rawValue)
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
}


