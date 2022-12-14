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
    
    // ?????????????????? ?????? ??????
    func setNavigationBar() {
        // ?????????????????? ?????? ????????? ??????
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: videoInformation.isFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(favoriteAction))
        completeButton = UIBarButtonItem(title: "??????", style: .plain, target: self, action: #selector(completeAction))
        self.navigationController?.setExpansionBackbuttonArea()

        // ?????????????????? ???????????? ??? ????????? ??? ?????????
        navigationController?.isToolbarHidden = false
        
        // ??????, ??????????????????, ?????? ??? ??????
        self.view.backgroundColor = .orrWhite
        
        // ?????? ?????? ????????? ??????
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
    // ???????????? ????????? ????????? ??? ??????
    @objc func exportAction() {
        //FIXME: Dodo ?????? ?????? ?????? ????????? ?????? ?????? ??????
        let exportViewController = ExportViewController()
        exportViewController.videoInformation = currentVideoInformation
        exportViewController.videoAsset = videoDetailPageViewController.videoDataFomatter(videoLocalIdentifier: videoInformation.videoLocalIdentifier!)
        self.present(exportViewController, animated: true)
    }
    
    // ????????? ???????????? ?????? ???????????? ??????
    @objc func showInfo() {
        isShowInfo.toggle()
        infoButton.image = UIImage(systemName: isShowInfo ? "info.circle.fill" : "info.circle")
        feedbackText = videoInfoView.feedbackTextView.text!
        if isShowInfo {
            videoDetailPageViewController.isPagingEnabled = false
            UIView.animate(withDuration: 0.2, animations: {
                self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: -430)
                self.videoDetailPageViewController.view.transform = CGAffineTransform(translationX: 0, y: -430)
                self.navigationController?.isNavigationBarHidden = true
                self.topSafeAreaView.layer.opacity = 0
                self.navigationController?.isToolbarHidden = false
                self.bottomSafeAreaView.layer.opacity = 1.0
            })
        } else {
            videoDetailPageViewController.isPagingEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                self.videoInfoView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.videoDetailPageViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.navigationController?.isNavigationBarHidden = false
                self.topSafeAreaView.layer.opacity = 1
            })
        }
    }
    
    // ???????????? ????????? ????????? ??? ??????
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    // ?????? ????????? ????????? ??? ??????
    @objc func deleteVideoAction(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: "????????? ?????? ????????????", message: "????????? ??????????????????????", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "??????", style: .destructive) {_ in
            DataManager.shared.deleteData(videoInformation: self.currentVideoInformation!)
            self.goBackAction()
        }
        let cancelAction = UIAlertAction(title: "??????", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // ?????? ????????? ????????? ??? ??????
    @objc func soundVideoAction() {
        isSounded.toggle()
        soundButton.image = UIImage(systemName: isSounded ? "speaker.wave.2.fill" : "speaker.slash.fill")
        VideoDetailViewControllerDelegate?.changeVideoSoundPlayAndStop()
    }
    
    // ?????? ????????? ????????? ??? ??????
    @objc func playVideoAction() {
        isPlayed.toggle()
        playButton.image = UIImage(systemName: isPlayed ? "play.fill" : "pause.fill")
        VideoDetailViewControllerDelegate?.changeVideoPlayAndStop()
        
    }
    
    // ????????? ????????? ????????? ??? ??????
    @objc func favoriteAction() {
        currentVideoInformation!.isFavorite.toggle()
        favoriteButton.image = UIImage(systemName: currentVideoInformation!.isFavorite ? "heart.fill" : "heart")
        DataManager.shared.updateFavorite(videoInformation: currentVideoInformation!, isFavorite: currentVideoInformation!.isFavorite)
    }
    
    // ?????? ????????? ????????? ??? ??????
    @objc func cancelAction() {
        feedbackText = currentVideoInformation!.feedback
        self.view.endEditing(true)
    }
    
    // ?????? ????????? ????????? ??? ??????
    @objc func completeAction() {
        //TODO: ????????? ?????? ?????? ?????????
        feedbackText = videoInfoView.feedbackTextView.text!
        DataManager.shared.updateFeedback(videoInformation: currentVideoInformation!, feedback: feedbackText!)
        self.view.endEditing(true)
    }
    
    // ????????? ???????????? ??? ??????????????????, ????????? ???????????? ??????
    override func viewWillLayoutSubviews() {
        // ????????????????????? ???????????? ??? ????????? ??????
        let isNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
        let backGroundColor = isNavigationBarHidden ? UIColor.orrBlack : UIColor.orrWhite
        view.backgroundColor = backGroundColor
        bottomSafeAreaView.backgroundColor = backGroundColor
        topSafeAreaView.backgroundColor = backGroundColor
    }
    
    // ????????? ??? ????????? ????????? ??? ?????? ?????? ???????????? ????????? ????????? ??????
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setDefaultData() {
        feedbackText = videoInformation.feedback
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

// ????????? ???????????? ???????????? ??????
extension VideoDetailViewController {
    // ????????? ?????????
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

// Video ?????? ?????? functions
private extension VideoDetailViewController {
    
    func videoDataFomatter(videoLocalIdentifier: String) -> PHAsset? {
        var videoIDArray: [String] = []
        videoIDArray.append(videoLocalIdentifier)
        
        // LocalIdentifier??? ???????????? ????????? PHAsset??? PHFetchResult<PHAsset> ???????????? ??????
        // ??????????????? ???????????? ?????? ????????? ?????? ??? ????????? ???????????? ???????????? ????????? ????????? ?????????
        let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: videoIDArray, options: .none)
        // ?????? : https://developer.apple.com/documentation/photokit/phasset/1624783-fetchassets
        
        // ???????????? ??????????????? ???????????? ??????
        guard phAsset.count != 0 else {
            print("DEBUG: ???????????? ???????????? ?????? ??? ????????????.")
            return nil
        }
        
        guard phAsset[0].mediaType == PHAssetMediaType.video
        else {
            print("DEBUG: ????????? ???????????? ???????????? ????????????.")
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
//         ?????? safe area??? ???????????? ???
        view.addSubview(bottomSafeAreaView)
        bottomSafeAreaView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.bottom.equalTo(self.view)
        }
        
        currentQueuePlayer =  VideoDetailViewControllerDelegate?.getCurrentQueuePlayer()
        currentVideoInformation =  VideoDetailViewControllerDelegate?.getCurrentVideoInformation()
        
        // ????????? ???????????? ???
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
