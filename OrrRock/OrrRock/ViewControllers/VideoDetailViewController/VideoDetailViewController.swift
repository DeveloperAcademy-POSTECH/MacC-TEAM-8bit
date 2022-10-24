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
	
	let videoInfoView: UIView = VideoInfoView()
	
	private var infoButton: UIBarButtonItem!
	private var feedbackButton: UIBarButtonItem!
	private var trashButton: UIBarButtonItem!
	
	private var favoriteButton: UIBarButtonItem!
	private var goBackButton: UIBarButtonItem!
	private var flexibleSpace: UIBarButtonItem!
	
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
		let embed = Bundle.main.url(forResource: "testVideo", withExtension: "MP4")
		let testVideoAsset = AVAsset(url: embed!)
		
		let view = VideoPlayView(asset: testVideoAsset)
		self.view.addSubview(view)
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setNavigationBar()
		setUpLayout()
	}
	
	// 네비게이션바 세팅 함수
	func setNavigationBar() {
		// 네비게이션바 버튼 아이템 생성
		flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		goBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBackAction))
		favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteAction))
		
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
		var items = [UIBarButtonItem]()
		
		[infoButton,flexibleSpace,feedbackButton,flexibleSpace,trashButton].forEach {
			items.append($0)
		}
		self.toolbarItems = items
	}
	
	// 정보를 보여주는 뷰를 띄워주는 함수
	@objc func showInfo() {
		isShowInfo.toggle()
		infoButton.image = UIImage(systemName: isShowInfo ? "info.circle.fill" : "info.circle")
		navigationController?.hidesBarsOnTap = !isShowInfo
		if isShowInfo {
			UIView.animate(withDuration: 0.2, animations: {
				self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: -500)
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
	
	// 뒤로가기 버튼을 눌렀을 때 로직
	@objc func goBackAction() {
		// !!!: 이건 나중에 다른 로직으로 구현 다시 한번 체크하기
		print(#function)
	}
	
	// 삭제 버튼을 눌렀을 때 로직
	@objc func deleteVideoAction() {
		// 삭제하기
		print(#function)
	}
	
	// 피드백 버튼을 눌렀을 때 로직
	@objc func feedbackAction() {
		// 피드백 + 키보드 보여주기
		print(#function)
	}
	
	// 좋아요 버튼을 눌렀을 때 로직
	@objc func favoriteAction() {
		isFavorite.toggle()
		favoriteButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
		print(#function)
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
		view.addSubview(videoInfoView)
		videoInfoView.snp.makeConstraints {
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
