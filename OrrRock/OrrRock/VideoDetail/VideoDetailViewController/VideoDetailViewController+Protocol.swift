//
//  VideoDetailViewController+Protocol.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/19.
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
        videoInfoView.refreshData(videoInfo: currentVideoInformation!)
        
        feedbackText = videoInfoView.feedbackTextView.text!
        DataManager.shared.updateFeedback(videoInformation: currentVideoInformation!, feedback: feedbackText!)
        self.view.endEditing(true)
    }
    
    func sendQueuePlayer(quque: AVQueuePlayer) {
        self.currentQueuePlayer = quque
    }
    
    
}
