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

    private lazy var failButton: UIButton = {
        let button = UIButton()
        button.setTitle("실패", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(fail), for: .touchUpInside)

        return button
    }()
    
    private lazy var successButton: UIButton = {
        let button = UIButton()
        button.setTitle("성공", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(success), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // card UI
        view.backgroundColor = .systemGroupedBackground
        setUpLayout()
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
    
    @objc func removeCard(card: UIView) {
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
    
    @objc func fail() {
        
    }
    
    @objc func success() {
        
    }

    func fetchVideo() {
        self.dummyVideos = VideoManager.shared.fetchVideo()
        
        print(self.dummyVideos)
    }
}

private extension SwipeableCardViewController {
    
    func setUpLayout() {
        let buttonStackView = UIStackView(arrangedSubviews: [failButton, successButton])
        buttonStackView.spacing = 40.0
        buttonStackView.distribution = .fillEqually
        
        // TODO: 디자인 수정 예정 (린다와 얘기 후) -> 임의의 cont 값 조절하였음
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100.0)
            $0.height.equalTo(40.0)
            $0.width.equalTo(300.0)
        }
    }
}

