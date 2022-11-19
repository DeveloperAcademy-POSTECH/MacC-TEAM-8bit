//
//  VideoDetailPageViewController+Extentions.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/19.
//

import UIKit
import AVFoundation

extension VideoDetailPageViewController : VideoDetailViewControllerDelegate{
    
    func getCurrentVideoInformation() -> VideoInformation {
        print((videoDetailPageViewControllerDelegate?.getCurrentVideoInformation())!)
        return (videoDetailPageViewControllerDelegate?.getCurrentVideoInformation())!
    }
    
    func getCurrentQueuePlayer() -> AVQueuePlayer {
        (videoDetailPageViewControllerDelegate?.getCurrentQueuePlayer())!
    }
    
}
