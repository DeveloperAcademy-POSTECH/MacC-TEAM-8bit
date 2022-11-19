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
}
