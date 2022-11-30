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
    
    var videoInfoView = VideoInfoView()
    
    var videoInformation: VideoInformation!
    
    var currentVideoInformation : VideoInformation?
    var currentQueuePlayer : AVQueuePlayer?
    var VideoDetailViewControllerDelegate : VideoDetailViewControllerDelegate?
    
    var feedbackText: String?
    
    var videoInformationArray: [VideoInformation] = []
    var currentIndex = 0
    lazy var videoDetailPageViewController = VideoDetailPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(respondToTapGesture(_:)))
    
    private var exportButton: UIBarButtonItem!
    private var infoButton: UIBarButtonItem!
    private var trashButton: UIBarButtonItem!
    var soundButton: UIBarButtonItem!
    var playButton: UIBarButtonItem!
    var favoriteButton: UIBarButtonItem!
    private var flexibleSpace: UIBarButtonItem!
    private var completeButton: UIBarButtonItem!
    
    lazy var topSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        
        return view
    }()
    
    lazy var bottomSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setKeyboardObserver()
        setDefaultData()
        addUIGesture()
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.navigationBar.layer.opacity = 1
        self.topSafeAreaView.layer.opacity = 1
    }
    
    // 네비게이션바 세팅 함수
    func setNavigationBar() {
        // 네비게이션바 버튼 아이템 생성
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: videoInformation.isFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(favoriteAction))
        completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeAction))
        self.navigationController?.setExpansionBackbuttonArea()

        // 네비게이션바 띄워주고 탭 되었을 때 숨기기
        navigationController?.isToolbarHidden = false
        
        // 배경, 네비게이션바, 툴바 색 지정
        self.view.backgroundColor = .orrWhite
        
        // 툴바 버튼 아이템 생성
        exportButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(exportAction))
        infoButton = UIBarButtonItem(image: UIImage(systemName: isShowInfo ? "info.circle.fill" : "info.circle"), style: .plain, target: self, action: #selector(showInfo))
        trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteVideoAction))
        soundButton = UIBarButtonItem(image: UIImage(systemName: "speaker.slash.fill"), style: .plain, target: self, action: #selector(soundVideoAction))
        soundButton.width = 40
        playButton = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(playVideoAction))
        playButton.width = 30
        
        var items = [UIBarButtonItem]()
        [exportButton,flexibleSpace,favoriteButton,flexibleSpace,playButton,flexibleSpace,soundButton,flexibleSpace,infoButton,flexibleSpace,trashButton].forEach {
            items.append($0)
        }
        self.toolbarItems = items
    }
    // 공유하기 버튼을 눌렀을 때 로직
    @objc func exportAction() {
        //FIXME: Dodo 파트 수정 이후 데이터 연결 수정 필요
        let exportViewController = ExportViewController()
        exportViewController.videoInformation = currentVideoInformation
        exportViewController.videoAsset = videoDetailPageViewController.videoDataFomatter(videoLocalIdentifier: videoInformation.videoLocalIdentifier!)
        self.present(exportViewController, animated: true)
    }
    
    // 정보를 보여주는 뷰를 띄워주는 함수
    @objc func showInfo() {
        isShowInfo.toggle()
        infoButton.image = UIImage(systemName: isShowInfo ? "info.circle.fill" : "info.circle")
        feedbackText = videoInfoView.feedbackTextView.text!
        if isShowInfo {
            UIView.animate(withDuration: 0.2, animations: {
                self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: -430)
                self.videoDetailPageViewController.view.transform = CGAffineTransform(translationX: 0, y: -430)
                self.navigationController?.isNavigationBarHidden = true
                self.topSafeAreaView.layer.opacity = 0
                self.navigationController?.isToolbarHidden = false
                self.bottomSafeAreaView.layer.opacity = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.videoDetailPageViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.navigationController?.isNavigationBarHidden = false
                self.topSafeAreaView.layer.opacity = 1
            })
        }
    }
    
    // 뒤로가기 버튼을 눌렀을 때 로직
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    // 삭제 버튼을 눌렀을 때 로직
    @objc func deleteVideoAction(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: "선택한 기록 삭제하기", message: "정말로 삭제하시겠어요?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {_ in
            DataManager.shared.deleteData(videoInformation: self.currentVideoInformation!)
            self.goBackAction()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // 소리 버튼을 눌렀을 때 로직
    @objc func soundVideoAction() {
        isSounded.toggle()
        soundButton.image = UIImage(systemName: isSounded ? "speaker.wave.2.fill" : "speaker.slash.fill")
        VideoDetailViewControllerDelegate?.changeVideoSoundPlayAndStop()
    }
    
    // 재생 버튼을 눌렀을 때 로직
    @objc func playVideoAction() {
        isPlayed.toggle()
        playButton.image = UIImage(systemName: isPlayed ? "play.fill" : "pause.fill")
        VideoDetailViewControllerDelegate?.changeVideoPlayAndStop()
        
    }
    
    // 좋아요 버튼을 눌렀을 때 로직
    @objc func favoriteAction() {
        currentVideoInformation!.isFavorite.toggle()
        favoriteButton.image = UIImage(systemName: currentVideoInformation!.isFavorite ? "heart.fill" : "heart")
        DataManager.shared.updateFavorite(videoInformation: currentVideoInformation!, isFavorite: currentVideoInformation!.isFavorite)
    }
    
    // 취소 버튼을 눌렀을 때 로직
    @objc func cancelAction() {
        feedbackText = currentVideoInformation!.feedback
        self.view.endEditing(true)
    }
    
    // 완료 버튼을 눌렀을 때 로직
    @objc func completeAction() {
        //TODO: 피드백 입력 구현 마무리
        
        feedbackText = videoInfoView.feedbackTextView.text!
        print(feedbackText)
        DataManager.shared.updateFeedback(videoInformation: currentVideoInformation!, feedback: feedbackText!)
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
            feedbackText = videoInfoView.feedbackTextView.text!
            DataManager.shared.updateFeedback(videoInformation: currentVideoInformation!, feedback: feedbackText!)
        }
    }
    
    @objc func hideKeyboard(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isShowKeyboard.toggle()
            feedbackText = videoInfoView.feedbackTextView.text!
            DataManager.shared.updateFeedback(videoInformation: currentVideoInformation!, feedback: feedbackText!)
        }
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        self.navigationController?.navigationBar.layer.opacity = UserDefaults.standard.float(forKey: "navState")
    }
    
}

// Video 처리 관련 functions
private extension VideoDetailViewController {
    
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

extension VideoDetailViewController {
    private func setUpLayout() {
        videoDetailPageViewController.videoInformationArray = videoInformationArray
        videoDetailPageViewController.currentIndex = currentIndex
        self.addChild(videoDetailPageViewController)
        self.view.addSubview(videoDetailPageViewController.view)
        self.view.addConstraints(videoDetailPageViewController.view.constraints)
        videoDetailPageViewController.didMove(toParent: self)
        videoDetailPageViewController.view.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.top.equalTo(self.view)
            $0.bottom.equalTo(self.view)
        }
        self.VideoDetailViewControllerDelegate = videoDetailPageViewController
        videoDetailPageViewController.sendtoVideoDetailViewControllerDelegate = self
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
        
        currentQueuePlayer =  VideoDetailViewControllerDelegate?.getCurrentQueuePlayer()
        currentVideoInformation =  VideoDetailViewControllerDelegate?.getCurrentVideoInformation()
        
        // 정보를 보여주는 뷰
        videoInfoView = VideoInfoView(frame: .zero, videoInfo: currentVideoInformation!)
        view.addSubview(videoInfoView)
        videoInfoView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.height.equalTo(650)
            $0.bottom.equalTo(self.view).offset(650)
        }
    }
}
