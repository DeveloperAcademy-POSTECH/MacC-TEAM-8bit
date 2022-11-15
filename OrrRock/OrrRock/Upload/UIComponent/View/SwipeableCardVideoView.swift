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
	
	var video: VideoInfo?
	let cornerRadius: CGFloat = 10
    var queuePlayer = AVQueuePlayer()
	private var player = AVPlayer()
	private var playerLayer: AVPlayerLayer?
	private var playerLooper: AVPlayerLooper?
	private var asset: AVAsset
	
	private lazy var videoBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .orrGray3
		view.layer.borderWidth = 3
		view.layer.cornerRadius = cornerRadius
		view.layer.borderColor = UIColor.white.cgColor
		// 스와이프 뷰에서 카드들이 다중 터치가 되지 않게 막는 코드
		view.isExclusiveTouch = true
		
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
	}
}

extension SwipeableCardVideoView {
	
	func setVideoBackgroundViewBorderColor(color: VideoBackgroundViewBorderColor,alpha: CGFloat) {
		var r : CGFloat = 0.0
		var g : CGFloat = 0.0
		var b : CGFloat = 0.0
		
		switch color {
		case.pass :
			r = 48; g = 176; b = 199
		case .fail :
			r = 242; g = 52; b = 52
		case .clear :
			r = 255; g = 255; b = 255
		}
		videoBackgroundView.layer.borderColor = UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha: 1.0).cgColor
	}
}
