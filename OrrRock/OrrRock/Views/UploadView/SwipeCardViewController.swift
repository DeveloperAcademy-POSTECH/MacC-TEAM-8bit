//
//  SwipeCardViewController.swift
//  OrrRock
//
//  Created by 이성노, Yeni Hwang on 2022/10/21.
//

import UIKit
import SnapKit

final class SwipeCardViewController: UIViewController {

    let gesture = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // card UI
        view.backgroundColor = .systemGroupedBackground
        showOtherCardToSwipe()
    }
}

// Gesture
private extension SwipeCardViewController {
    
    // 목업용 카드를 만들어줍니다.
    func showOtherCardToSwipe() {
        for card in 0...2 {
            let swipeCard = SwipeCardView()
            view.addSubview(swipeCard)

            swipeCard.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(60.0)
                $0.height.equalTo(450.0)
                $0.centerY.equalToSuperview()
            }
            
//            swipeCard.addSubview(imageView)
            
            // gesture
            gesture.addTarget(self, action: #selector(handlerCard))
            swipeCard.addGestureRecognizer(gesture)
        }
    }
    
    // Gesture
    @objc func handlerCard (_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view {
            let point = gesture.translation(in: view)
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)

            let rotationAngle = point.x / view.bounds.width * 0.4

            card.transform = CGAffineTransform(rotationAngle: rotationAngle)

            if gesture.state == .ended {
                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                    card.transform = .identity
                }
            }
        }
    }
}
