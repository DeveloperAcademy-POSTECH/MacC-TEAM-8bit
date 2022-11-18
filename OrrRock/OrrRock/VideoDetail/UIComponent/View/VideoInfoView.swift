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
		return view
	}()
	
	private lazy var dateView: UIView = {
		let view = UIView()
		view.backgroundColor = .orrGray100
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var levelView: UIView = {
		let view = UIView()
		view.backgroundColor = .orrGray100
		view.layer.cornerRadius = 10
		return view
	}()
	
	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20.0, weight: .bold)
		label.textColor = .orrBlack
		label.text = videoDate
		return label
	}()
	
	private lazy var levelLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20.0, weight: .bold)
		label.textColor = .orrBlack
		label.text = videoLevel
		return label
	}()
	
	private lazy var locationLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12.0, weight: .regular)
		label.textColor = .orrGray500
		label.text = videoLocation
		return label
	}()
	
	private lazy var isSucceeded: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12.0, weight: .regular)
		label.textColor = .orrGray500
		label.text = videoIsSucceeded ? "성공" : "실패"
		return label
	}()
	
	private lazy var dateLocationEditButton: UIButton = {
		let button = UIButton()
		button.setTitle("편집", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.3), for: .highlighted)
		button.addTarget(self, action: #selector(dateLocationEdit), for: .touchUpInside)
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
	
	@objc private func dateLocationEdit() {
		print(#function)
		// 날짜, 클라이밍장 편집 뷰 네비게이션
		let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
		let vc = DateAndGymEditViewController()
		vc.videoInformation = videoInformation
		vc.completioHandler = { [self] gymName, date in
			self.dateLabel.text = date.timeToString()
			locationLabel.text = gymName
		}
		viewController.present(vc, animated: true)
	}
	
	@objc private func levelPFEdit() {
		print(#function)
		// 난이도, 성패여부 편집 뷰 네비게이션
		let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
		let vc = LevelAndPFEditViewController()
		vc.videoInformation = videoInformation
		vc.pickerSelectValue = Int(videoInformation!.problemLevel) + 1
		vc.completioHandler = { isSuccess, level in
			
			self.levelLabel.text = level == -1 ? "선택안함" : "V\(level)"
			
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
		self.videoInformation = videoInfo
		dateLabel.text = videoInformation?.gymVisitDate.timeToString()
		levelLabel.text = videoInformation?.problemLevel == -1 ? "선택안함" : "V\(videoInformation?.problemLevel ?? -3)"
		isSucceeded.text = videoInformation!.isSucceeded ? "성공" : "실패"
		locationLabel.text = videoInformation?.gymName
		feedbackTextView.text = videoInformation?.feedback
		feedbackTextView.delegate = self  // 플레이스 홀더를 위한 델리게이트
		feedbackTextView.textColor = feedbackTextView.text.isEmpty || feedbackTextView.text == nil ? .placeholderText : .orrBlack
		//make here what you want
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

extension VideoInfoView {
	@objc private func setUpLayout() {
		// textView
		self.addSubview(feedbackTextView)
		feedbackTextView.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(OrrPadding.padding3.rawValue)
			$0.top.equalTo(self.snp.top).offset(OrrPadding.padding3.rawValue)
			$0.height.equalTo(110)
		}
		// 날짜 입력 뷰
		self.addSubview(dateView)
		dateView.snp.makeConstraints {
			$0.height.equalTo(80)
			$0.leading.trailing.equalToSuperview().inset(OrrPadding.padding3.rawValue)
			$0.top.equalTo(feedbackTextView.snp.bottom).offset(OrrPadding.padding3.rawValue)
		}
		// 문제 난이도 뷰
		self.addSubview(levelView)
		levelView.snp.makeConstraints {
			$0.height.equalTo(80)
			$0.leading.trailing.equalToSuperview().inset(OrrPadding.padding3.rawValue)
			$0.top.equalTo(dateView.snp.bottom).offset(OrrPadding.padding3.rawValue)
		}
		// 날짜 레이블
		dateView.addSubview(dateLabel)
		dateLabel.snp.makeConstraints {
			$0.top.equalTo(dateView.snp.top).offset(OrrPadding.padding4.rawValue)
			$0.leading.equalTo(dateView.snp.leading).offset(OrrPadding.padding4.rawValue)
		}
		// 클라이밍장 정보
		dateView.addSubview(locationLabel)
		locationLabel.snp.makeConstraints {
			$0.bottom.equalTo(dateView.snp.bottom).inset(OrrPadding.padding4.rawValue)
			$0.leading.equalTo(dateView.snp.leading).inset(OrrPadding.padding4.rawValue)
		}
		// 난이도 레이블
		levelView.addSubview(levelLabel)
		levelLabel.snp.makeConstraints {
			$0.top.equalTo(levelView.snp.top).offset(OrrPadding.padding4.rawValue)
			$0.leading.equalTo(levelView.snp.leading).offset(OrrPadding.padding4.rawValue)
		}
		// 성공 여부 레이블
		levelView.addSubview(isSucceeded)
		isSucceeded.snp.makeConstraints {
			$0.bottom.equalTo(levelView.snp.bottom).inset(OrrPadding.padding4.rawValue)
			$0.leading.equalTo(levelView.snp.leading).inset(OrrPadding.padding4.rawValue)
		}
		// 날짜, 클라이밍장 편집 버튼
		dateView.addSubview(dateLocationEditButton)
		dateLocationEditButton.snp.makeConstraints {
			$0.centerY.equalTo(dateView.snp.centerY)
			$0.trailing.equalTo(dateView.snp.trailing).inset(OrrPadding.padding4.rawValue)
		}
		// 난이도, 성패여부 편집 버튼
		levelView.addSubview(levelPFEditButton)
		levelPFEditButton.snp.makeConstraints {
			$0.centerY.equalTo(levelView.snp.centerY)
			$0.trailing.equalTo(levelView.snp.trailing).inset(OrrPadding.padding4.rawValue)
		}
	}
}


