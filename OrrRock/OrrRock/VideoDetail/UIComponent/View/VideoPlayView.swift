//
//  VideoPlayView.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/23.
//

import AVFoundation
import UIKit
import Photos

import SnapKit

final class VideoPlayView: UIView {
	
	var queuePlayer = AVQueuePlayer()
	private var playerLooper: AVPlayerLooper?
	private var playerLayer: AVPlayerLayer?
	private var videoAsset: PHAsset?
	
	private lazy var videoBackgroundView: UIView = {
		let view = UIView()
		return view
	}()
	
	private lazy var warningView: UIView = {
		let view = UIView()
		
		let warningLabel = UILabel()
		warningLabel.text = "앨범에서 영상이 삭제되어\n해당 영상을 재생할 수 없습니다."
		warningLabel.textColor = .orrGray600
		warningLabel.textAlignment = .center
		warningLabel.numberOfLines = 2
		
		view.addSubview(warningLabel)
		warningLabel.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		return view
	}()
	
	init(videoAsset: PHAsset?) {
		self.videoAsset = videoAsset
		super.init(frame: .zero)
		
		setUpLayout()
		
		loadVideo(videoAsset: videoAsset)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.playerLayer?.frame = self.videoBackgroundView.bounds
	}
	
	func loadVideo(videoAsset: PHAsset?) {
		guard let videoAsset = videoAsset else { return }
		// 비디오 Asset의 콘텐츠 및 상태를 나타내는 AVFoundation 개체가 비동기식으로 로드되도록 요청
		// AVAsset?, AVAudioMix?, [AnyHashable : Any]? 타입으로 반환
		PHCachingImageManager().requestAVAsset(forVideo: videoAsset, options: nil) { (assets, audioMix, info) in
			// 참고 : https://developer.apple.com/documentation/photokit/phimagemanager/1616935-requestavasset
			
			// 비동기적으로 로드되는 AVFoundation 개체를 받아 Player로 재생
			DispatchQueue.main.async {
				let item = AVPlayerItem(asset: assets!)
				self.queuePlayer = AVQueuePlayer()
				let playerLayer = AVPlayerLayer(player: self.queuePlayer)
				playerLayer.frame = self.videoBackgroundView.bounds
				playerLayer.videoGravity = .resizeAspectFill
				self.playerLayer = playerLayer
				self.videoBackgroundView.layer.addSublayer(playerLayer)
				self.queuePlayer.isMuted = true
				self.playerLooper = AVPlayerLooper(player: self.queuePlayer, templateItem: item)
				self.queuePlayer.play()
			}
		}
	}
}

private extension VideoPlayView {
	func setUpLayout() {
		// AVPlayerLayer의 뒤에 위치할 뷰
		self.addSubview(videoBackgroundView)
		videoBackgroundView.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
		if videoAsset == nil {
			self.addSubview(warningView)
			warningView.snp.makeConstraints {
				$0.top.leading.trailing.equalToSuperview()
				$0.bottom.equalToSuperview()
			}
		}
	}
}
