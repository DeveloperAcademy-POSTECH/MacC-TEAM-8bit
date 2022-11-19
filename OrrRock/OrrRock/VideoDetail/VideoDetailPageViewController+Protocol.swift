//
//  VideoDetailPageViewController+Protocol.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/19.
//

import AVKit

protocol VideoDetailPageViewControllerDelegate : AnyObject{
    func getCurrentVideoInformation() -> VideoInformation
    func getCurrentQueuePlayer() -> AVQueuePlayer
}
