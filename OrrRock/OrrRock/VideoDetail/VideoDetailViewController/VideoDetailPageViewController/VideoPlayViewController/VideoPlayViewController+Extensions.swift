//
//  VideoPlayViewController+Extensions.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/19.
//

import UIKit
import AVFoundation

extension VideoPlayViewController : VideoDetailPageViewControllerDelegate{
    func changeVideoSoundPlayAndStop() {
        if queuePlayer.isMuted{
            queuePlayer.isMuted = false
        }
        else{
            queuePlayer.isMuted = true
        }
    }
    
    func changeVideoPlayAndStop() {
        if queuePlayer.timeControlStatus == .playing{
            queuePlayer.pause()
        }else{
            queuePlayer.play()
        }
    }
    
    func getCurrentVideoInformation() -> VideoInformation {
        return videoInformation!
    }
    
    func getCurrentQueuePlayer() -> AVQueuePlayer {
        return queuePlayer
    }
    
    
}
