//
//  VideoDetailViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/23.
//

import AVFoundation
import UIKit
import Photos

import SnapKit

//final class VideoDetailViewController: UIViewController {
class VideoDetailViewController: UIViewController {
    
    var isShowInfo: Bool = false
    var isSounded: Bool = false
    var isPlayed: Bool = false
    var isShowKeyboard: Bool = false
    var iconSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    
    var videoInfoView = VideoInfoView()
    
    var videoInformation: VideoInformation!
    var videoAsset: PHAsset?
    
    var feedbackText: String?
    
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
        let view = VideoPlayView(videoAsset: videoAsset)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideoAsset()

        setNavigationBar()
        setUpLayout()
        setKeyboardObserver()
        setDefaultData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.layer.opacity = 1
        self.topSafeAreaView.layer.opacity = 1
    }
    // 네비게이션바 세팅 함수
    func setNavigationBar() {
        // 네비게이션바 버튼 아이템 생성
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        goBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBackAction))
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: videoInformation.isFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(favoriteAction))
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
        feedbackText = videoInfoView.feedbackTextView.text!
        feedbackButton.title = videoInfoView.feedbackTextView.textColor == .placeholderText ? "피드백 입력하기" : "피드백 확인하기"
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
    }
    
    // 뒤로가기 버튼을 눌렀을 때 로직
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        navigationController?.hidesBarsOnTap = false
    }
    
    // 삭제 버튼을 눌렀을 때 로직
    @objc func deleteVideoAction(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: "선택한 영상 삭제하기", message: "정말로 삭제하시겠어요?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) {_ in
            DataManager.shared.deleteData(videoInformation: self.videoInformation)
            self.goBackAction()
        }
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
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
        feedbackText = videoInfoView.feedbackTextView.text!
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
        videoInformation.isFavorite.toggle()
        favoriteButton.image = UIImage(systemName: videoInformation.isFavorite ? "heart.fill" : "heart")
        DataManager.shared.updateFavorite(videoInformation: videoInformation, isFavorite: videoInformation.isFavorite)
        print(#function)
    }
    
    // 취소 버튼을 눌렀을 때 로직
    @objc func cancelAction() {
        feedbackText = videoInformation.feedback
        self.view.endEditing(true)
    }
    
    // 완료 버튼을 눌렀을 때 로직
    @objc func completeAction() {
        //TODO: 피드백 입력 구현 마무리
        
        feedbackText = videoInfoView.feedbackTextView.text!
        DataManager.shared.updateFeedback(videoInformation: videoInformation, feedback: feedbackText!)
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
    
    func setDefaultData() {
        feedbackText = videoInformation.feedback
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
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
            feedbackText = videoInfoView.feedbackTextView.text!
            DataManager.shared.updateFeedback(videoInformation: videoInformation, feedback: feedbackText!)
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
            feedbackText = videoInfoView.feedbackTextView.text!
            DataManager.shared.updateFeedback(videoInformation: videoInformation, feedback: feedbackText!)
        }
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        self.navigationController?.navigationBar.layer.opacity = UserDefaults.standard.float(forKey: "navState")
    }
    
}

// Video 처리 관련 functions
private extension VideoDetailViewController {
    func loadVideoAsset() {
        guard let videoAsset = videoDataFomatter(videoLocalIdentifier: videoInformation.videoLocalIdentifier ?? "") else {
            // 영상이 없어 fetch를 하지 못한 경우
            print("영상이 없음")
            return
        }
        
        self.videoAsset = videoAsset
    }
    
    func videoDataFomatter(videoLocalIdentifier: String) -> PHAsset? {
        var videoIDArray: [String] = []
        videoIDArray.append(videoLocalIdentifier)
        
        // LocalIdentifier를 기반으로 불러온 PHAsset을 PHFetchResult<PHAsset> 타입으로 변환
        // 클래스에서 사용하는 것과 동일한 방법 및 규칙을 사용하여 가져오기 결과의 내용에 액세스
        let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: videoIDArray, options: .none)
        // 참고 : https://developer.apple.com/documentation/photokit/phasset/1624783-fetchassets
        
        // 미디어가 존재하는지 확인하는 코드
        guard phAsset.count != 0 else {
            print("DEBUG: 앨범에서 비디오를 찾을 수 없습니다.")
            return nil
        }
        
        guard phAsset[0].mediaType == PHAssetMediaType.video
        else {
            print("DEBUG: 비디오 미디어가 존재하지 않습니다.")
            return nil
        }
        
        return phAsset[0]
    }
}

// PHAsset 타입의 영상 데이터를 videoLocalIdentifier를 통해서 AVAsset으로 포매팅하는 매서드
extension VideoDetailViewController {
    
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
