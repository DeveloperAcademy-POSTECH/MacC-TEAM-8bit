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

    private var dummyVideos: [DummyVideo] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스와이프를 통해 비디오를 분류해주세요."
        label.textColor = .orrBlack
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)

        return label
    }()

    private lazy var levelButton: UIButton = {
        let button = UIButton()
        button.setTitle("레벨", for: .normal)
        button.setTitleColor(.orrGray3, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
        button.addTarget(self, action: #selector(pickLevel), for: .touchUpInside)

        return button
    }()

    private lazy var levelButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .orrGray3
        
        return imageView
    }()

    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .orrUPBlue
        
        return separator
    }()
    
    private lazy var emptyVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray2
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var emptyVideoInformation: UILabel = {
        let label = UILabel()
        label.text = "모든 비디오를 분류했습니다!"
        label.textColor = .orrGray3
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        
        return label
    }()
    
    private lazy var failButton: UIButton = {
        let button = UIButton()
        button.setTitle("실패", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        // TODO: - .orrfail 에셋 문제 해결 후 수정하기
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 37.0
        button.addTarget(self, action: #selector(didFailButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var successButton: UIButton = {
        let button = UIButton()
        button.setTitle("성공", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        button.backgroundColor = .orrPass
        button.layer.cornerRadius = 37.0
        button.addTarget(self, action: #selector(didSuccessButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.orrUPBlue!, for: .normal)
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        button.setTitle("저장하기", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10.0
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = .orrUPBlue
        
        // card UI
        setUpLayout()
        fetchVideo()
        createSwipeableCard()
    }
}

extension SwipeableCardViewController: LevelPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: String) {
        levelButton.setTitle(selectedLevel, for: .normal)
        if !selectedLevel.isEmpty {
            levelButton.setTitleColor(.black, for: .normal)
            separator.backgroundColor = .black
        }
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
                view.layer.cornerRadius = 10
                view.clipsToBounds = true
                
                return view
            }()

            swipeCard.dummyVideo = dummyVideo
            swipeCard.tag = dummyVideo.id

            // gesture
            let gesture = UIPanGestureRecognizer()
            gesture.addTarget(self, action: #selector(handlerCard))
            swipeCard.addGestureRecognizer(gesture)
            
            view.insertSubview(swipeCard, at: 0)

            swipeCard.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.height.equalTo(420.0)
                $0.leading.trailing.equalToSuperview().inset(60.0)
            }
            
            self.view.sendSubviewToBack(self.emptyVideoView)
        }
    }

    // swipeCard가 SuperView에서 제거됩니다.
    @objc func removeCard(card: UIView) {
        card.removeFromSuperview()
        
        self.dummyVideos = self.dummyVideos.filter ({ dummyVideos in
            return dummyVideos.id != card.tag
        })
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
                    animateCard(rotationAngle: rotationAngle, videoResultType: .success)
                    return
                }
                
                if card.center.x < -20 {
                    animateCard(rotationAngle: rotationAngle, videoResultType: .fail)
                    return
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

    @objc func pickLevel() {
        let nextViewController = LevelPickerView()
        self.navigationController?.present(nextViewController, animated: true)
        nextViewController.delegate = self
    }

    @objc func didFailButton() {
        animateCard(rotationAngle: -0.4, videoResultType: .fail)
    }
    
    @objc func didSuccessButton() {
        animateCard(rotationAngle: 0.4, videoResultType: .success)
    }
    
    @objc func tapSaveButton() {
        // TODO: - 다음 뷰로 넘어가는 로직
    }
    
    func fetchVideo() {
        self.dummyVideos = VideoManager.shared.fetchVideo()
        
        print(self.dummyVideos)
    }
    
    // swipeCard의 애니매이션 효과를 담당합니다.
    func animateCard(rotationAngle: CGFloat, videoResultType: VideoResultType) {
        if let dummyVideo = dummyVideos.first {
            for view in view.subviews {
                if view.tag == dummyVideo.id {
                    if let card = view as? SwipeableCardVideoView {
                        let center: CGPoint
                        let isSuccess: Bool
                        
                        switch videoResultType {
                        case .fail:
                            center = CGPoint(x: card.center.x - view.bounds.width, y: card.center.y + 50)
                            isSuccess = false
                            
                        case .success:
                            center = CGPoint(x: card.center.x + view.bounds.width, y: card.center.y + 50)
                            isSuccess = true
                        }
                        
                        UIView.animate(withDuration: 0.6, animations: {
                            card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            card.successImageView.alpha = isSuccess == true ? 1 : 0
                            card.failImageView.alpha = isSuccess == false ? 1 : 0
                        }) { _ in
                            self.removeCard(card: card)
                        }
                    }
                }
            }
        }
        if dummyVideos.count == 1 {
            saveButton.isHidden = false
            successButton.isHidden = true
            failButton.isHidden = true
        }
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
        print("pop 가 됐습니다.")
    }
}

private extension SwipeableCardViewController {
    
    func setUpLayout() {
        let buttonStackView = UIStackView(arrangedSubviews: [levelButton, levelButtonImage])
        buttonStackView.spacing = 8.0
        buttonStackView.distribution = .fillProportionally
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(104.0)
        }
    
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
        }
        
        levelButtonImage.snp.makeConstraints {
            $0.height.equalTo(20.0)
            $0.width.equalTo(20.0)
        }

        view.addSubview(emptyVideoView)
        emptyVideoView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(420.0)
            $0.leading.trailing.equalToSuperview().inset(60.0)
        }
        
        view.addSubview(separator)
        separator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(8.0)
            $0.height.equalTo(2.0)
            $0.width.equalTo(70.0)
        }

        emptyVideoView.addSubview(emptyVideoInformation)
        emptyVideoInformation.snp.makeConstraints {
            $0.center.equalTo(emptyVideoView.snp.center)
        }

        view.addSubview(failButton)
        failButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64.0)
            $0.leading.equalToSuperview().inset(48.0)
            $0.height.equalTo(74.0)
            $0.width.equalTo(74.0)
        }
        
        view.addSubview(successButton)
        successButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64.0)
            $0.trailing.equalToSuperview().inset(48.0)
            $0.height.equalTo(74.0)
            $0.width.equalTo(74.0)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(30.0)
            $0.height.equalTo(56.0)
        }
    }
}
