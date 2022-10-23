//
//  VideoDetailViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/23.
//

import UIKit

import SnapKit

final class VideoDetailViewController: UIViewController {
	
	// FIXME: data관련 임시 코드 coreData 연동 시 추후 변경
	var isFavortie: Bool = false
	// -----------------------------
	
	var isShowInfo: Bool = false
	
	let videoPlayView: UIView = VideoPlayView()
	let videoInfoView: UIView = VideoInfoView()
	
	var infoButton: UIBarButtonItem!
	var feedbackButton: UIBarButtonItem!
	var trashButton: UIBarButtonItem!
	
	private var favoriteButton: UIBarButtonItem!
	private var goBackButton: UIBarButtonItem!
	private var flexibleSpace: UIBarButtonItem!
	
	private lazy var topSafeareaView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	private lazy var bottomSafeareaView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
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
		self.view.backgroundColor = .white
		navigationController?.navigationBar.backgroundColor = .white
		navigationController?.toolbar.backgroundColor = .white
		
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
		if isShowInfo {
			infoButton.image = UIImage(systemName: "info.circle.fill")
			navigationController?.hidesBarsOnTap = false
			UIView.animate(withDuration: 0.2, animations: {
				self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: -500)
				self.videoPlayView.transform = CGAffineTransform(translationX: 0, y: -100)
				self.navigationController?.navigationBar.layer.opacity = 0
				self.topSafeareaView.layer.opacity = 0
			})
		} else {
			infoButton.image = UIImage(systemName: "info.circle")
			navigationController?.hidesBarsOnTap = true
			UIView.animate(withDuration: 0.2, animations: {
				self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: 0)
				self.videoPlayView.transform = CGAffineTransform(translationX: 0, y: 0)
				self.navigationController?.navigationBar.layer.opacity = 1
				self.topSafeareaView.layer.opacity = 1
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
		isFavortie.toggle()
		if isFavortie {
			favoriteButton.image = UIImage(systemName: "heart.fill")
		} else {
			favoriteButton.image = UIImage(systemName: "heart")
		}
		print(#function)
	}
	
	// 영상을 클릭했을 때 네비게이션바, 툴바가 사라지는 로직
	override func viewWillLayoutSubviews() {
		// 네비게이션바가 숨겨졌을 때 배경색 변경
		let isNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
		view.backgroundColor = isNavigationBarHidden ? .black : .white
		bottomSafeareaView.backgroundColor = isNavigationBarHidden ? .black : .white
		topSafeareaView.backgroundColor = isNavigationBarHidden ? .black : .white
	}
}

extension VideoDetailViewController {
	private func setUpLayout() {
		// 영상을 보여주는 뷰
		view.addSubview(videoPlayView)
		videoPlayView.snp.makeConstraints {
			$0.left.equalTo(self.view)
			$0.right.equalTo(self.view)
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			$0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
		}
		// 정보를 보여주는 뷰
		view.addSubview(videoInfoView)
		videoInfoView.snp.makeConstraints {
			$0.left.equalTo(self.view)
			$0.right.equalTo(self.view)
			$0.height.equalTo(650)
			$0.bottom.equalTo(self.view).offset(700)
		}
		// 상단 safetyarea를 가려주는 뷰
		view.addSubview(topSafeareaView)
		topSafeareaView.snp.makeConstraints {
			$0.left.equalTo(self.view)
			$0.right.equalTo(self.view)
			$0.top.equalTo(self.view)
			$0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
		}
		// 하단 safetyarea를 가려주는 뷰
		view.addSubview(bottomSafeareaView)
		bottomSafeareaView.snp.makeConstraints {
			$0.left.equalTo(self.view)
			$0.right.equalTo(self.view)
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
			$0.bottom.equalTo(self.view)
		}
	}
}
