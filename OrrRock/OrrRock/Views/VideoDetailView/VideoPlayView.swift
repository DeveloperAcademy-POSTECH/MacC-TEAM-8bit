//
//  VideoPlayView.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/23.
//

import AVFoundation
import UIKit
import Photos

final class VideoPlayView: UIView {
	
	private lazy var videoBackgroundView: UIView = {
		let view = UIView()
		return view
	}()
	
	var videoInformation : VideoInformation?
	
	var queuePlayer = AVQueuePlayer()
	private var playerLooper: AVPlayerLooper?
	private var playerLayer: AVPlayerLayer?
	
	private var stringArray: [String]
	
	init(videoInformation : VideoInformation) {
		self.videoInformation = videoInformation
		self.stringArray = []
		super.init(frame: .zero)
		
		setUpLayout()
		
		// PHAsset 기본 메서드 fetchAssets의 포맷을 맞추기 위한 String 배열 생성 및 데이터 삽입
		stringArray.append((videoInformation.videoLocalIdentifier ?? nil)!)
		videoDataFomatter(videoLocalIdentifier: stringArray)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.playerLayer?.frame = self.videoBackgroundView.bounds
	}
}

// AVPlayerLayer에 AVAsset파일을 받아와서 띄워주는 코드
private extension VideoPlayView {
	
	func videoDataFomatter(videoLocalIdentifier: [String]) {
		// LocalIdentifier를 기반으로 불러온 PHAsset을 PHFetchResult<PHAsset> 타입으로 변환
		// 클래스에서 사용하는 것과 동일한 방법 및 규칙을 사용하여 가져오기 결과의 내용에 액세스
		let phasset = PHAsset.fetchAssets(withLocalIdentifiers: videoLocalIdentifier, options: .none)
		// 참고 : https://developer.apple.com/documentation/photokit/phasset/1624783-fetchassets
		
		// 미디어가 존재하는지 확인하는 코드
		guard (phasset[0].mediaType == PHAssetMediaType.video)
		else {
			print("비디오 미디어가 존재하지 않습니다.")
			return
		}
		
		// 비디오 Asset의 콘텐츠 및 상태를 나타내는 AVFoundation 개체가 비동기식으로 로드되도록 요청
		// AVAsset?, AVAudioMix?, [AnyHashable : Any]? 타입으로 반환
		PHCachingImageManager().requestAVAsset(forVideo: phasset[0], options: nil) { (assets, audioMix, info) in
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
			$0.bottom.equalToSuperview().inset(50)
		}
	}
}
