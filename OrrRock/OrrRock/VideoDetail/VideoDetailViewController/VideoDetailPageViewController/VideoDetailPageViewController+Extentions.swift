//
//  VideoDetailPageViewController+Extentions.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/19.
//

import UIKit
import AVFoundation

extension VideoDetailPageViewController : VideoDetailViewControllerDelegate {
    func changeVideoSoundPlayAndStop() {
        videoDetailPageViewControllerDelegate!.changeVideoSoundPlayAndStop()
    }
    
    func changeVideoPlayAndStop() {
        videoDetailPageViewControllerDelegate?.changeVideoPlayAndStop()
    }
    
    func getCurrentVideoInformation() -> VideoInformation {
        return (videoDetailPageViewControllerDelegate?.getCurrentVideoInformation())!
    }
    
    func getCurrentQueuePlayer() -> AVQueuePlayer {
        (videoDetailPageViewControllerDelegate?.getCurrentQueuePlayer())!
    }
    
}

extension VideoDetailViewController : VideoInfoViewTextViewDelegate {
    func tapReturnButton() {
        completeAction()
    }
    
    
}
