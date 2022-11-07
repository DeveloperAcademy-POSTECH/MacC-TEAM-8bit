//
//  SwipeableCardViewController.swift
//  OrrRock
//
//  Created by 이성노, Yeni Hwang on 2022/10/21.
//

import UIKit

import AVFoundation
import AVKit
import SnapKit
import Photos

final class SwipeableCardViewController: UIViewController {
	
	var videoInfoArray: [VideoInfo] = []
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "스와이프를 통해 비디오를 분류해주세요."
		label.textColor = .orrBlack
		label.font = .systemFont(ofSize: 17.0, weight: .semibold)
		
		return label
	}()
	
	private lazy var levelButton: UIButton = {
		let button = UIButton()
		button.setTitle("레벨", for: .normal)
		button.setTitleColor(.orrGray3, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
		button.addTarget(self, action: #selector(pickLevel), for: .touchUpInside)
		
		return button
	}()
	
	private lazy var levelButtonImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "chevron.down")
		imageView.tintColor = .orrGray3
		
		return imageView
	}()
	
	private lazy var buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .equalSpacing
		stackView.spacing = 8
		
		return stackView
	}()
	
	private lazy var separator: UIView = {
		let separator = UIView()
		separator.backgroundColor = .orrUPBlue
		
		return separator
	}()
	
	private lazy var emptyVideoView: UIView = {
		let view = UIView()
		view.backgroundColor = .orrGray2
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		
		return view
	}()
	
	private lazy var emptyVideoInformation: UILabel = {
		let label = UILabel()
		label.text = "모든 비디오를 분류했습니다!"
		label.textColor = .orrGray3
		label.font = .systemFont(ofSize: 15.0, weight: .regular)
		
		return label
	}()
	
	private lazy var failButton: UIButton = {
		let button = UIButton()
		button.setTitle("실패", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
		button.backgroundColor = .orrFail
		button.layer.cornerRadius = 37.0
		button.addTarget(self, action: #selector(didFailButton), for: .touchUpInside)
		
		return button
	}()
	
	private lazy var successButton: UIButton = {
		let button = UIButton()
		button.setTitle("성공", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
		button.backgroundColor = .orrPass
		button.layer.cornerRadius = 37.0
		button.addTarget(self, action: #selector(didSuccessButton), for: .touchUpInside)
		
		return button
	}()
	
	private lazy var saveButton : UIButton = {
		let button = UIButton()
		button.setBackgroundColor(.orrUPBlue!, for: .normal)
		button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
		button.setTitle("저장하기", for: .normal)
		button.clipsToBounds = true
		button.layer.cornerRadius = 10.0
		button.setTitleColor(.white, for: .normal)
		button.isHidden = true
		
		return button
	}()
	
	private var cards: [SwipeableCardVideoView?] = []
	private var counter: Int = 0
	private var currentSelectedLevel: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
		navigationItem.leftBarButtonItem?.tintColor = .orrUPBlue
		
		// card UI
		setUpLayout()
		
		createSwipeableCard() {
			self.cards.forEach { swipeCard in
				self.view.insertSubview(swipeCard!, at: 0)
				swipeCard!.snp.makeConstraints {
					$0.center.equalToSuperview()
					$0.height.equalTo(420.0)
					$0.leading.trailing.equalToSuperview().inset(60.0)
				}
				
				self.view.sendSubviewToBack(self.emptyVideoView)
				
				// gesture
				let gesture = UIPanGestureRecognizer()
				gesture.addTarget(self, action: #selector(self.handlerCard))
				swipeCard!.addGestureRecognizer(gesture)
			}
			
			CustomIndicator.stopLoading()
		}
	}
}

extension SwipeableCardViewController: LevelPickerViewDelegate {
	
	func didLevelChanged(selectedLevel: Int) {
		levelButton.setTitle("V\(selectedLevel)", for: .normal)
		currentSelectedLevel = selectedLevel
		
		levelButton.setTitleColor(.black, for: .normal)
		separator.backgroundColor = .black
	}
}

// Gesture
private extension SwipeableCardViewController {
	
	// 목업용 카드를 만들어줍니다.
	func createSwipeableCard(_ completion: @escaping () -> Void) {
		
		var identifiers: [String] = []
		for videoInfo in videoInfoArray {
			identifiers.append(videoInfo.videoLocalIdentifier)
		}
		
		// 날짜 기준으로 정렬하는 PHFetchOptions 설정
		let option = PHFetchOptions()
		option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
		
		// identifiers를 기반으로 불러온 PHAsset을 PHFetchResult<PHAsset> 타입으로 변환
		let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: option)
		// PHFetchResult<PHAsset>의 Asset 개수만큼 배열 공간 할당
		cards = Array(repeating: nil, count: assets.count)
		// Asset 카운팅을 위한 디스패치 그룹
		let countingGroup = DispatchGroup()

		CustomIndicator.startLoading()
		
		for index in 0..<assets.count {
			
			// Asset 카운팅 +1
			countingGroup.enter()
			
			// 미디어가 존재하는지 확인하는 코드
			guard (assets[index].mediaType == PHAssetMediaType.video)
			else {
				print("비디오 미디어가 존재하지 않습니다.")
				return
			}
			
			// 클라우드에서 Asset을 받아올 일이 생겼을 때 나는 오류 해결을 위한 PHVideoRequestOptions 설정
			let option = PHVideoRequestOptions()
			option.isNetworkAccessAllowed = true
			
			PHCachingImageManager().requestAVAsset(forVideo: assets[index], options: option) { (assets, audioMix, info) in
				
				let asset = assets as? AVURLAsset
				
				guard let url = asset?.url else {
					return
				}
				
				// Main Thread에서 View를 디스패치 그룹
				DispatchQueue.main.async(group: countingGroup) {
					
					let swipeCard = SwipeableCardVideoView(asset: AVAsset(url: url))
					
					swipeCard.embedVideo()
					
					self.cards[index] = swipeCard
					
					// Asset 카운팅 -1
					countingGroup.leave()
					
				}
				// Asset 카운팅이 0이 되었을 때 completionHandler로 반환
				countingGroup.notify(queue: DispatchQueue.main) {
					completion()
				}
			}
		}
	}
	
	// swipeCard가 SuperView에서 제거됩니다.
	@objc func removeCard(card: UIView) {
		card.removeFromSuperview()
	}
	
	// Gesture
	@objc func handlerCard(_ gesture: UIPanGestureRecognizer) {
		if let card = gesture.view as? SwipeableCardVideoView {
			let point = gesture.translation(in: view)
			
			card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
			
			let rotationAngle = point.x / view.bounds.width * 0.4
			
			if point.x > 0 {
				card.successImageView.alpha = rotationAngle * 5
				card.failImageView.alpha = 0
				card.setVideoBackgroundViewBorderColor(color: .pass, alpha: rotationAngle * 5)
			} else {
				card.successImageView.alpha = 0
				card.failImageView.alpha = -rotationAngle * 5
				card.setVideoBackgroundViewBorderColor(color: .fail, alpha: -rotationAngle * 5)
			}
			
			card.transform = CGAffineTransform(rotationAngle: rotationAngle)
			
			if gesture.state == .ended {
				if card.center.x > self.view.bounds.width + 20 {
					animateCard(rotationAngle: rotationAngle, videoResultType: .success)
					return
				}
				
				if card.center.x < -20 {
					animateCard(rotationAngle: rotationAngle, videoResultType: .fail)
					return
				}
				
				UIView.animate(withDuration: 0.2) {
					card.center = self.view.center
					card.transform = .identity
					card.successImageView.alpha = 0
					card.failImageView.alpha = 0
					card.setVideoBackgroundViewBorderColor(color: .clear, alpha: 1)
				}
			}
		}
	}
	
	@objc func pickLevel() {
		let nextViewController = LevelPickerView()
		self.navigationController?.present(nextViewController, animated: true)
		nextViewController.delegate = self
	}
	
	@objc func didFailButton() {
		animateCard(rotationAngle: -0.4, videoResultType: .fail)
	}
	
	@objc func didSuccessButton() {
		animateCard(rotationAngle: 0.4, videoResultType: .success)
	}
	
	@objc func tapSaveButton() {
		// TODO: - 다음 뷰로 넘어가는 로직
		DataManager.shared.createMultipleData(infoList: videoInfoArray)
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	// swipeCard의 애니매이션 효과를 담당합니다.
	func animateCard(rotationAngle: CGFloat, videoResultType: VideoResultType) {
		
		print(view.subviews.count)
		var cardViews = view.subviews.filter({ ($0 as? SwipeableCardVideoView) != nil })
		print("DDD ", cardViews.count)
		
		for view in cardViews {
			if view == cards[counter] {
				let center: CGPoint
				let isSuccess: Bool
				let  card = view as! SwipeableCardVideoView
				
				switch videoResultType {
				case .fail:
					center = CGPoint(x: card.center.x - view.bounds.width, y: card.center.y + 30)
					isSuccess = false
					
				case .success:
					center = CGPoint(x: card.center.x + view.bounds.width, y: card.center.y + 30)
					isSuccess = true
				}
				
				videoInfoArray[counter].isSucceeded = isSuccess
				videoInfoArray[counter].problemLevel = currentSelectedLevel ?? 0
				print(videoInfoArray[counter])
				UIView.animate(withDuration: 0.6, animations: {
					card.center = center
					card.transform = CGAffineTransform(rotationAngle: rotationAngle)
					card.successImageView.alpha = isSuccess == true ? 1 : 0
					card.failImageView.alpha = isSuccess == false ? 1 : 0
					if isSuccess{
						card.setVideoBackgroundViewBorderColor(color: .pass, alpha: 1)
					} else {
						card.setVideoBackgroundViewBorderColor(color: .fail, alpha: 1)
					}
					
				}) { [self] _ in
					if counter != cards.count-1 {
						print("DEBUG : \(counter) / \(cards.count - 1)")
						removeCard(card: card)
						counter += 1
					} else {
						didVideoClassificationComplete()
						removeCard(card: card)
					}
				}
			}
		}
	}
	
	@objc func backButtonClicked() {
		self.navigationController?.popViewController(animated: true)
		print("pop 가 됐습니다.")
	}
	
	func didVideoClassificationComplete() {
		levelButton.isEnabled = false
		
		saveButton.isHidden = false
		successButton.isHidden = true
		failButton.isHidden = true
		
		titleLabel.text = "분류 완료! 저장하기를 눌러주세요."
		levelButton.setTitle("레벨", for: .normal)
		
		titleLabel.textColor = .orrGray3
		levelButton.tintColor = .orrGray3
		separator.backgroundColor = .orrGray3
	}
}

private extension SwipeableCardViewController {
	
	func setUpLayout() {
		
		[levelButton, levelButtonImage].map {
			self.buttonStackView.addArrangedSubview($0)
		}
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickLevel))
		buttonStackView.isUserInteractionEnabled = true
		buttonStackView.addGestureRecognizer(tapGestureRecognizer)
		
		view.addSubview(titleLabel)
		titleLabel.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.top.equalToSuperview().inset(104.0)
		}
		
		view.addSubview(buttonStackView)
		buttonStackView.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.top.equalTo(titleLabel.snp.bottom).offset(24.0)
			$0.centerX.equalToSuperview()
		}
		
		levelButtonImage.snp.makeConstraints {
			$0.height.equalTo(20.0)
			$0.width.equalTo(20.0)
		}
		
		view.addSubview(emptyVideoView)
		emptyVideoView.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.height.equalTo(420.0)
			$0.leading.trailing.equalToSuperview().inset(60.0)
		}
		
		view.addSubview(separator)
		separator.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.top.equalTo(buttonStackView.snp.bottom).offset(8.0)
			$0.height.equalTo(2.0)
			$0.width.equalTo(70.0)
		}
		
		emptyVideoView.addSubview(emptyVideoInformation)
		emptyVideoInformation.snp.makeConstraints {
			$0.center.equalTo(emptyVideoView.snp.center)
		}
		
		view.addSubview(failButton)
		failButton.snp.makeConstraints {
			$0.bottom.equalToSuperview().inset(64.0)
			$0.leading.equalToSuperview().inset(48.0)
			$0.height.equalTo(74.0)
			$0.width.equalTo(74.0)
		}
		
		view.addSubview(successButton)
		successButton.snp.makeConstraints {
			$0.bottom.equalToSuperview().inset(64.0)
			$0.trailing.equalToSuperview().inset(48.0)
			$0.height.equalTo(74.0)
			$0.width.equalTo(74.0)
		}
		
		view.addSubview(saveButton)
		saveButton.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(16.0)
			$0.bottom.equalToSuperview().inset(30.0)
			$0.height.equalTo(56.0)
		}
	}
}
