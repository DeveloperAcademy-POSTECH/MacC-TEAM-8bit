//
//  VideoDetailPageViewController+Protocol.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/19.
//

import AVKit

protocol VideoDetailPageViewControllerDelegate : AnyObject{
    func getCurrentVideoInformation() -> VideoInformation
    func getCurrentQueuePlayer() -> AVQueuePlayer
    func changeVideoPlayAndStop()
    func changeVideoSoundPlayAndStop()
}

protocol SendtoVideoDetailViewControllerDelegate: AnyObject{
    func sendVideoInfomation(videoInformation : VideoInformation)
    func sendQueuePlayer(quque : AVQueuePlayer)
}
