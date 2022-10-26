//
//  VideoDetailViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/23.
//

import AVFoundation
import UIKit

import SnapKit

final class VideoDetailViewController: UIViewController {
	
	// FIXME: data관련 임시 코드 coreData 연동 시 추후 변경
	var isFavorite: Bool = false
	// -----------------------------
	
	var isShowInfo: Bool = false
	var isSounded: Bool = false
	var isPlayed: Bool = false
	var isShowKeyboard: Bool = false
	var iconSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
	
    var videoInfoView: UIView?
	
    //VideoInfo - 꼬마가 사용할 데이터
    var videoInformation: VideoInformation!
    
	private var infoButton: UIBarButtonItem!
	private var feedbackButton: UIBarButtonItem!
	private var trashButton: UIBarButtonItem!
	private var soundButton: UIBarButtonItem!
	private var playButton: UIBarButtonItem!
	private var favoriteButton: UIBarButtonItem!
	private var goBackButton: UIBarButtonItem!
	private var flexibleSpace: UIBarButtonItem!
	private var cancelButton: UIBarButtonItem!
	private var completeButton: UIBarButtonItem!
	
	private lazy var topSafeAreaView: UIView = {
		let view = UIView()
		view.backgroundColor = .orrWhite
		return view
	}()
	
	private lazy var bottomSafeAreaView: UIView = {
		let view = UIView()
		view.backgroundColor = .orrWhite
		return view
	}()
	
	// 영상 재생하는 뷰 (VideoPlayerView)
	lazy var videoPlayView: VideoPlayView = {
		// FIXME: 임시 데이터 입력을 위한 코드 추후 변경
		// 추후 PHAsset 타입의 데이터를 AVAsset으로 타입 포매팅 후 url을 가져오는 코드로 변경
		let embed = Bundle.main.url(forResource: "ianIsComming", withExtension: "MOV")
		let testVideoAsset = AVAsset(url: embed!)
		
		let view = VideoPlayView(asset: testVideoAsset)
		self.view.addSubview(view)
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setNavigationBar()
		setUpLayout()
		setKeyboardObserver()
	}
	
	// 네비게이션바 세팅 함수
	func setNavigationBar() {
		// 네비게이션바 버튼 아이템 생성
		flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		goBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBackAction))
		favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteAction))
		cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
		completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeAction))
		
		// 네비게이션바 띄워주고 탭 되었을 때 숨기기
		navigationController?.isToolbarHidden = false
		navigationController?.hidesBarsOnTap = true
		
		// 배경, 네비게이션바, 툴바 색 지정
		self.view.backgroundColor = .orrWhite
		navigationController?.navigationBar.backgroundColor = .orrWhite
		navigationController?.toolbar.backgroundColor = .orrWhite
		
		navigationItem.leftBarButtonItem = goBackButton
		navigationItem.rightBarButtonItem = favoriteButton
		
		// 툴바 버튼 아이템 생성
		infoButton = UIBarButtonItem(image: UIImage(systemName: isShowInfo ? "info.circle.fill" : "info.circle"), style: .plain, target: self, action: #selector(showInfo))
		feedbackButton = UIBarButtonItem(title: "피드백 입력하기", style: .plain, target: self, action: #selector(feedbackAction))
		trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteVideoAction))
		soundButton = UIBarButtonItem(image: UIImage(systemName: "speaker.slash.fill"), style: .plain, target: self, action: #selector(soundVideoAction))
		var items = [UIBarButtonItem]()
		playButton = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(playVideoAction))
		iconSpace.width = 8.4
		
		[soundButton,iconSpace,flexibleSpace,playButton,flexibleSpace,feedbackButton,flexibleSpace,infoButton,flexibleSpace,trashButton].forEach {
			items.append($0)
		}
		self.toolbarItems = items
	}
	
	// 정보를 보여주는 뷰를 띄워주는 함수
	@objc func showInfo() {
		isShowInfo.toggle()
		infoButton.image = UIImage(systemName: isShowInfo ? "info.circle.fill" : "info.circle")
		navigationController?.hidesBarsOnTap = !isShowInfo
		feedbackButton.title = self.videoInfoView.feedbackTextView.textColor == .placeholderText ? "피드백 입력하기" : "피드백 확인하기"
		if isShowInfo {
			UIView.animate(withDuration: 0.2, animations: {
                self.videoInfoView!.transform = CGAffineTransform(translationX: 0, y: -500)
				self.videoPlayView.transform = CGAffineTransform(translationX: 0, y: -100)
				self.navigationController?.navigationBar.layer.opacity = 0
				self.topSafeAreaView.layer.opacity = 0
			})
		} else {
			UIView.animate(withDuration: 0.2, animations: {
                self.videoInfoView!.transform = CGAffineTransform(translationX: 0, y: 0)
				self.videoPlayView.transform = CGAffineTransform(translationX: 0, y: 0)
				self.navigationController?.navigationBar.layer.opacity = 1
				self.topSafeAreaView.layer.opacity = 1
			})
		}
		print(#function)
	}
	
	// 뒤로가기 버튼을 눌렀을 때 로직
	@objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        navigationController?.hidesBarsOnTap = false
	}
	
	// 삭제 버튼을 눌렀을 때 로직
	@objc func deleteVideoAction() {
		// 삭제하기
		print(#function)
	}
	
	// 소리 버튼을 눌렀을 때 로직
	@objc func soundVideoAction() {
		isSounded.toggle()
		iconSpace.width = isSounded ? 0 : 8.4
		soundButton.image = UIImage(systemName: isSounded ? "speaker.wave.2.fill" : "speaker.slash.fill")
		videoPlayView.queuePlayer.isMuted = isSounded ? false : true
		print(#function)
	}
	
	// 재생 버튼을 눌렀을 때 로직
	@objc func playVideoAction() {
		isPlayed.toggle()
		playButton.image = UIImage(systemName: isPlayed ? "play.fill" : "pause.fill")
		isPlayed ? videoPlayView.queuePlayer.pause() : videoPlayView.queuePlayer.play()
		print(#function)
	}
	
	// 피드백 버튼을 눌렀을 때 로직
	@objc func feedbackAction() {
		isShowInfo.toggle()
		infoButton.image = UIImage(systemName: isShowInfo ? "info.circle.fill" : "info.circle")
		navigationController?.hidesBarsOnTap = !isShowInfo
		feedbackButton.title = self.videoInfoView.feedbackTextView.textColor == .placeholderText ? "피드백 입력하기" : "피드백 확인하기"
		if isShowInfo {
			UIView.animate(withDuration: 0.2, animations: {
				self.videoInfoView.feedbackTextView.becomeFirstResponder()
				self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: -430)
				self.videoPlayView.transform = CGAffineTransform(translationX: 0, y: -100)
				self.navigationController?.navigationBar.layer.opacity = 0
				self.topSafeAreaView.layer.opacity = 0
			})
		} else {
			UIView.animate(withDuration: 0.2, animations: {
				self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: 0)
				self.videoPlayView.transform = CGAffineTransform(translationX: 0, y: 0)
				self.navigationController?.navigationBar.layer.opacity = 1
				self.topSafeAreaView.layer.opacity = 1
			})
		}
		print(#function)
	}
	
	// 좋아요 버튼을 눌렀을 때 로직
	@objc func favoriteAction() {
		isFavorite.toggle()
		favoriteButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
		print(#function)
	}
	
	// 취소 버튼을 눌렀을 때 로직
	@objc func cancelAction() {
		self.view.endEditing(true)
	}
	
	// 완료 버튼을 눌렀을 때 로직
	@objc func completeAction() {
		//TODO: 피드백 입력 구현 마무리
		var feedbackText: String = self.videoInfoView.feedbackTextView.text
		updateFeedback(videoInformation: VideoInformation, feedback: feedbackText)
		self.view.endEditing(true)
	}
	
	// 영상을 클릭했을 때 네비게이션바, 툴바가 사라지는 로직
	override func viewWillLayoutSubviews() {
		// 네비게이션바가 숨겨졌을 때 배경색 변경
		let isNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
		let backGroundColor = isNavigationBarHidden ? UIColor.orrBlack : UIColor.orrWhite
		view.backgroundColor = backGroundColor
		bottomSafeAreaView.backgroundColor = backGroundColor
		topSafeAreaView.backgroundColor = backGroundColor
	}
	
	// 텍스트 뷰 활성화 상태일 때 여백 화면 터치해서 키보드 내리는 로직
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

// 키보드 올라오고 내려감을 인식
extension VideoDetailViewController {
	// 키보드 옵저버
	func setKeyboardObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object:nil)
	}
	
	@objc func showKeyboard(notification: NSNotification) {
		if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			isShowKeyboard.toggle()
			self.navigationController?.navigationBar.layer.opacity = 1
			self.topSafeAreaView.layer.opacity = 1
			// 키보드의 유무에 따라 버튼 옵션 변경
			navigationItem.leftBarButtonItem = isShowKeyboard ? cancelButton : goBackButton
			navigationItem.rightBarButtonItem = isShowKeyboard ? completeButton : favoriteButton
			print(#function)
		}
	}
	
	@objc func hideKeyboard(notification: NSNotification) {
		if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			isShowKeyboard.toggle()
			self.navigationController?.navigationBar.layer.opacity = 0
			self.topSafeAreaView.layer.opacity = 0
			// 키보드의 유무에 따라 버튼 옵션 변경
			navigationItem.leftBarButtonItem = isShowKeyboard ? cancelButton : goBackButton
			navigationItem.rightBarButtonItem = isShowKeyboard ? completeButton : favoriteButton
			print(#function)
		}
	}
}

extension VideoDetailViewController {
	private func setUpLayout() {
		// 영상을 보여주는 뷰
		view.addSubview(videoPlayView)
		videoPlayView.snp.makeConstraints {
			$0.leading.equalTo(self.view)
			$0.trailing.equalTo(self.view)
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			$0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
		}
		// 정보를 보여주는 뷰
        videoInfoView = VideoInfoView(frame: .zero, videoInfo: videoInformation)
        view.addSubview(videoInfoView!)
        videoInfoView!.snp.makeConstraints {
			$0.leading.equalTo(self.view)
			$0.trailing.equalTo(self.view)
			$0.height.equalTo(650)
			$0.bottom.equalTo(self.view).offset(700)
		}
		// 상단 safe area를 가려주는 뷰
		view.addSubview(topSafeAreaView)
		topSafeAreaView.snp.makeConstraints {
			$0.leading.equalTo(self.view)
			$0.trailing.equalTo(self.view)
			$0.top.equalTo(self.view)
			$0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
		}
		// 하단 safe area를 가려주는 뷰
		view.addSubview(bottomSafeAreaView)
		bottomSafeAreaView.snp.makeConstraints {
			$0.leading.equalTo(self.view)
			$0.trailing.equalTo(self.view)
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
			$0.bottom.equalTo(self.view)
		}
	}
    

}
