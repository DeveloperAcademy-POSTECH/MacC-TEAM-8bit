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
        isPlayed = false
        playButton.image = UIImage(systemName: "pause.fill")
        isSounded = false
        soundButton.image = UIImage(systemName: "speaker.slash.fill")
        favoriteButton.image = UIImage(systemName: currentVideoInformation!.isFavorite ? "heart.fill" : "heart")
    }
    
    func sendQueuePlayer(quque: AVQueuePlayer) {
        self.currentQueuePlayer = quque
    }
    
    
}
