//
//  VideoPlayViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/18.
//

import AVFoundation
import UIKit
import Photos
import SnapKit

class VideoPlayViewController: UIViewController {
    
    var queuePlayer = AVQueuePlayer()
    var playerLooper: AVPlayerLooper?
    var playerLayer: AVPlayerLayer?
    var videoAsset: PHAsset?
    
    var videoInformation : VideoInformation?
    
    var index: Int = 0
    
    private lazy var videoBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var warningView: UIView = {
        let view = UIView()
        
        let warningLabel = UILabel()
        warningLabel.text = "앨범에서 영상이 삭제되어\n해당 영상을 재생할 수 없습니다."
        warningLabel.textColor = .orrGray4
        warningLabel.textAlignment = .center
        warningLabel.numberOfLines = 2
        
        view.addSubview(warningLabel)
        warningLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo(videoAsset: videoAsset)
        setUpLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.playerLayer?.frame = self.videoBackgroundView.bounds
    }
}


extension VideoPlayViewController{
    func setUpLayout() {
        // AVPlayerLayer의 뒤에 위치할 뷰
        view.addSubview(videoBackgroundView)
        videoBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        if videoAsset == nil {
            view.addSubview(warningView)
            warningView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    func loadVideo(videoAsset: PHAsset?) {
        guard let videoAsset = videoAsset else {
            print("novideoasset")
            return }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.queuePlayer.isMuted = true
    }
}
