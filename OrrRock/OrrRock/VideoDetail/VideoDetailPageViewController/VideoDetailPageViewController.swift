//
//  VideoDetailPageViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/18.
//

import UIKit
import Photos
import SnapKit

class VideoDetailPageViewController: UIPageViewController {
    
    var videoInformationArray: [VideoInformation] = []
    var photos: [UIImage]!
    var currentIndex = 0
    var nextIndex: Int?
    var videoInformation : VideoInformation?
    var videoAsset: PHAsset?
    
    var videoDetailPageViewControllerDelegate : VideoDetailPageViewControllerDelegate?
    var sendtoVideoDetailViewControllerDelegate : SendtoVideoDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        videoInformation = videoInformationArray[currentIndex]
        view.backgroundColor = .orrWhite
        
        self.delegate = self
        self.dataSource = self
        let vc = VideoPlayViewController()
        vc.videoInformation = videoInformationArray[currentIndex]
        vc.videoAsset = checkVideoAsset(videoLocalIdentifier: self.videoInformationArray[currentIndex].videoLocalIdentifier ?? "")
        vc.index = currentIndex
        self.videoDetailPageViewControllerDelegate = vc
        self.setViewControllers([vc], direction: .forward, animated: false)
        // Do any additional setup after loading the view.
    }
    
    
    
}

extension VideoDetailPageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == 0 {
            return nil
        }
        let vc = VideoPlayViewController()
        vc.videoAsset = checkVideoAsset(videoLocalIdentifier: self.videoInformationArray[currentIndex - 1].videoLocalIdentifier ?? "")
        vc.index = currentIndex - 1
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == (self.videoInformationArray.count - 1) {
            return nil
        }
        let vc = VideoPlayViewController()
        vc.videoAsset = checkVideoAsset(videoLocalIdentifier: self.videoInformationArray[currentIndex + 1].videoLocalIdentifier ?? "")
        vc.index = currentIndex + 1
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextVC = pendingViewControllers.first as? VideoPlayViewController else {
            return
        }
        nextVC.videoAsset = checkVideoAsset(videoLocalIdentifier: self.videoInformationArray[nextVC.index].videoLocalIdentifier ?? "")
        nextVC.loadVideo(videoAsset: nextVC.videoAsset)
        nextVC.videoInformation = videoInformationArray[nextVC.index]
        
        self.videoDetailPageViewControllerDelegate = nextVC
        self.nextIndex = nextVC.index
        sendtoVideoDetailViewControllerDelegate?.sendQueuePlayer(quque: (videoDetailPageViewControllerDelegate?.getCurrentQueuePlayer())!)
        sendtoVideoDetailViewControllerDelegate?.sendVideoInfomation(videoInformation: (videoDetailPageViewControllerDelegate?.getCurrentVideoInformation())!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed && self.nextIndex != nil) {
            self.currentIndex = self.nextIndex!
        }
        
        self.nextIndex = nil
        
    }
    
}

extension VideoDetailPageViewController{
    func checkVideoAsset(videoLocalIdentifier : String)-> PHAsset?{
        guard let videoAsset = videoDataFomatter(videoLocalIdentifier: videoLocalIdentifier) else {
            // 영상이 없어 fetch를 하지 못한 경우
            return nil
        }
        
        return videoAsset
    }
    
    
    func loadVideoAsset() {
        guard let videoAsset = videoDataFomatter(videoLocalIdentifier: videoInformation!.videoLocalIdentifier ?? "") else {
            // 영상이 없어 fetch를 하지 못한 경우
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
