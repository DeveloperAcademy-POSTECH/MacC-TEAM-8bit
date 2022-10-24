//
//  SwipeableCardViewController.swift
//  OrrRock
//
//  Created by 이성노, Yeni Hwang on 2022/10/21.
//

import UIKit

import AVFoundation
import AVKit
import SnapKit

final class SwipeableCardViewController: UIViewController {

    var dummyVideos: [DummyVideo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // card UI
        view.backgroundColor = .systemGroupedBackground
        fetchVideo()
        createSwipeableCard()
    }
}

// Gesture
private extension SwipeableCardViewController {
    
    // 목업용 카드를 만들어줍니다.
    func createSwipeableCard() {
        for dummyVideo in dummyVideos {
            lazy var swipeCard: SwipeableCardVideoView = {
                let embed = Bundle.main.url(forResource: dummyVideo.videoURL, withExtension: "MOV")
                let testVideoAsset = AVAsset(url: embed!)
                
                let view = SwipeableCardVideoView(asset: testVideoAsset)
                self.view.addSubview(view)
                return view
            }()

            swipeCard.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(60.0)
                $0.height.equalTo(450.0)
                $0.centerY.equalToSuperview()
            }
            
            view.addSubview(swipeCard)
            
            // gesture
            let gesture = UIPanGestureRecognizer()
            gesture.addTarget(self, action: #selector(handlerCard))
            swipeCard.addGestureRecognizer(gesture)
        }
    }
    
    func removeCard(card: UIView) {
        card.removeFromSuperview()
    }
    
    // Gesture
    @objc func handlerCard(_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view as? SwipeableCardVideoView {
            let point = gesture.translation(in: view)
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x > 0 {
                card.successImageView.alpha = rotationAngle * 5
                card.failImageView.alpha = 0
            } else {
                card.successImageView.alpha = 0
                card.failImageView.alpha = -rotationAngle * 5
            }

            card.transform = CGAffineTransform(rotationAngle: rotationAngle)

            if gesture.state == .ended {
                if card.center.x > self.view.bounds.width + 20 {
                    removeCard(card: card)
                }

                if card.center.x < -20 {
                    removeCard(card: card)
                }

                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                    card.transform = .identity
                    card.successImageView.alpha = 0
                    card.failImageView.alpha = 0
                }
            }
        }
    }

    func fetchVideo() {
        self.dummyVideos = VideoManager.shared.fetchVideo()
        
        print(self.dummyVideos)
    }
}
