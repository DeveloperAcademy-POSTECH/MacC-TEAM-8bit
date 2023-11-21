//
//  SwipeableCardVideoView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/22.
//

import UIKit
import AVKit
import AVFoundation

import SnapKit
import Then

final class SwipeableCardVideoView: UIView {
    
    var video: VideoInfo?
    let cornerRadius: CGFloat = 10
    var queuePlayer = AVQueuePlayer()
    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    private var playerLooper: AVPlayerLooper?
    private var asset: AVAsset
    
    private lazy var videoBackgroundView: UIView = .init().then {
        $0.backgroundColor = .orrGray500
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = cornerRadius
        $0.layer.borderColor = UIColor.orrWhite!.cgColor
        $0.isExclusiveTouch = true
    }
    
    let successImageView: UIImageView = .init().then {
        $0.image = UIImage(named: "success")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .orrPass
        $0.alpha = 0.0
    }
    
    let failImageView: UIImageView = .init().then {
        $0.image = UIImage(named: "fail")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .orrFail
        $0.alpha = 0.0
    }
    
    private lazy var countVideoView: UIView = .init().then {
        $0.backgroundColor = .orrBlack?.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }
    
    lazy var countVideoLabel: UILabel = .init().then {
        $0.text = ""
        $0.textColor = .orrWhite
        $0.font = .systemFont(ofSize: 12.0, weight: .regular)
    }
    
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
        self.playerLayer?.masksToBounds = true
        self.playerLayer?.cornerRadius = cornerRadius
    }
    
    func getCardLabelText(labelText:String){
        countVideoLabel.text = labelText
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
            videoBackgroundView.layer.borderColor = UIColor.orrWhite!.cgColor
        }
    }
}

extension SwipeableCardVideoView {
    
    func embedVideo() {
        let item = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer()
        let playerLayer = AVPlayerLayer(player: self.queuePlayer)
        playerLayer.frame = self.videoBackgroundView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer = playerLayer
        self.videoBackgroundView.layer.addSublayer(playerLayer)
        self.queuePlayer.isMuted = true
        self.playerLooper = AVPlayerLooper(player: self.queuePlayer, templateItem: item)
        self.queuePlayer.pause()
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
        
        self.addSubview(countVideoView)
        countVideoView.snp.makeConstraints {
            $0.bottom.equalTo(videoBackgroundView.snp.bottom).inset(OrrPd.pd16.rawValue)
            $0.centerX.equalTo(videoBackgroundView.snp.centerX)
            $0.height.equalTo(24)
            $0.width.equalTo(71)
        }
        
        countVideoView.addSubview(countVideoLabel)
        countVideoLabel.snp.makeConstraints {
            $0.center.equalTo(countVideoView.snp.center)
        }
    }
}

extension SwipeableCardVideoView {
    
    func setVideoBackgroundViewBorderColor(color: VideoBackgroundViewBorderColor,alpha: CGFloat) {
        var myColor = UIColor.orrWhite
        switch color {
        case.pass :
            myColor = .orrPass
        case .fail :
            myColor = .orrFail
        case .delete:
            myColor = .orrGray500
        case .clear :
            myColor = .orrWhite
        }
        videoBackgroundView.layer.borderColor = myColor?.withAlphaComponent(1.0).cgColor
    }
}
