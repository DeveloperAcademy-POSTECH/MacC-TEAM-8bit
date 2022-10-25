//
//  SwipeableCardVideoView.swift
//  OrrRock
//
//  Created by Yeni Hwang, 이성노 on 2022/10/22.
//

import UIKit

import SnapKit
import AVKit
import AVFoundation

final class SwipeableCardVideoView: UIView {

    var dummyVideo: VideoInfo? {
        didSet {
            if let dummyVideo = dummyVideo {
                self.asset = AVAsset(url: Bundle.main.url(forResource: "ianIsComming", withExtension: "MOV")!)
            }
        }
    }
    
    private lazy var videoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        
        return view
    }()

    let successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success")
        imageView.alpha = 0.0

        return imageView
    }()

    let failImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fail")
        imageView.alpha = 0.0

        return imageView
    }()

    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    private var asset: AVAsset

    init(asset: AVAsset) {
        self.asset = asset
        super.init(frame: .zero)

        setUpLayout()
        embedVideo()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.playerLayer?.frame = self.videoBackgroundView.bounds
    }
}

private extension SwipeableCardVideoView {
    
    func embedVideo() {
        let item = AVPlayerItem(asset: asset)
        self.player.replaceCurrentItem(with: item)
        
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.videoBackgroundView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        self.playerLayer = playerLayer
        self.videoBackgroundView.layer.addSublayer(playerLayer)
        self.player.play()
    }
}

private extension SwipeableCardVideoView {
    
    func setUpLayout() {
        self.addSubview(videoBackgroundView)
        videoBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(successImageView)
        successImageView.snp.makeConstraints {
             $0.top.equalTo(videoBackgroundView.snp.top).offset(16.0)
             $0.leading.equalTo(videoBackgroundView.snp.leading).offset(16.0)
             $0.height.equalTo(30.0)
             $0.width.equalTo(150.0)
         }

        self.addSubview(failImageView)
         failImageView.snp.makeConstraints {
             $0.top.equalTo(videoBackgroundView.snp.top).offset(16.0)
             $0.trailing.equalTo(videoBackgroundView.snp.trailing).offset(-16.0)
             $0.height.equalTo(30.0)
             $0.width.equalTo(100.0)
         }
    }
}
