//
//  VideoDetailViewController+Protocol.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/19.
//

import AVFoundation
import UIKit

protocol VideoDetailViewControllerDelegate{
    func getCurrentVideoInformation() -> VideoInformation
    func getCurrentQueuePlayer() -> AVQueuePlayer
    func changeVideoPlayAndStop()
    func changeVideoSoundPlayAndStop()
}

extension VideoDetailViewController : SendtoVideoDetailViewControllerDelegate{
    func sendVideoInfomation(videoInformation: VideoInformation) {
        self.currentVideoInformation = videoInformation
        print(currentVideoInformation)
    }
    
    func sendQueuePlayer(quque: AVQueuePlayer) {
        self.currentQueuePlayer = quque
        print(currentQueuePlayer,"213")
    }
    
    
}
