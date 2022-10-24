//
//  SwipeableCardVideoView.swift
//  OrrRock
//
//  Created by 이성노 on 2022/10/22.
//

import UIKit

import SnapKit
import AVKit
import AVFoundation

final class SwipeableCardVideoView: UIView {

    private lazy var videoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        
        return slider
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
    private let asset: AVAsset

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
    
    @objc private func changeValue() {
        self.player.seek(to: CMTime(seconds: Double(self.slider.value), preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { _ in
            print("completion")
        })
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
        
        if self.player.currentItem?.status == .readyToPlay {
            self.slider.minimumValue = 0
            self.slider.maximumValue = Float(CMTimeGetSeconds(item.duration))
        }
        
        self.slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
            let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        })
    }
}

private extension SwipeableCardVideoView {
    
    func setUpLayout() {
        self.addSubview(videoBackgroundView)
        videoBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
        
        self.addSubview(slider)
        slider.snp.makeConstraints {
            $0.top.equalTo(videoBackgroundView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
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
