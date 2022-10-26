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
import Photos

final class SwipeableCardViewController: UIViewController {

    var videoInfoArray: [VideoInfo] = []
    
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
    
    private var cards: [SwipeableCardVideoView] = []
    private var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = .orrUPBlue
        
        // card UI
        setUpLayout()
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
        
//        let identifiers = ["0FAB51F9-292E-4063-B9DA-116A82478F31/L0/001",
//                           "E2AF7BA4-FC5C-434B-9F89-604DB7390C8E/L0/001",
//                           "192E5D25-37AB-4CF8-802C-7EC9118250F1/L0/001",
//                           "8C925304-7B39-42DB-8653-DBF5CD420541/L0/001",
//                           "45B439B4-98DC-4BC0-B897-48F9EE801AB9/L0/001",
//                           "09B406A3-D991-439F-9873-DE51D6A5D66B/L0/001",
//                           "123DB5F8-CCDE-492A-B6BE-04FEB90C6724/L0/001",
//                           "A2A9A990-364A-4FEB-9AC3-FE01B5EFAA07/L0/001",
//                           "87FD3C13-2816-43E2-B966-BEAD0FEA16EA/L0/001",
//                           "C3D74F7F-949F-4E97-BC20-ABE18DB5D24D/L0/001",
//                           "F4722B4E-847D-4C0C-B213-749DCDA1E279/L0/001",
//                           "FAB3A40A-34D3-4C7A-A775-A92E4D066B7A/L0/001",
//                           "AAE0A4CE-7438-434B-9E7F-87758C7FE4DB/L0/001",
//                           "94AB1FD7-1DB5-4734-B862-8B572A69A74B/L0/001",
//                           "342BD2E7-BE07-42AC-B4B3-19992E51EBBA/L0/001"]
        
//        let identifiers = ["0FAB51F9-292E-4063-B9DA-116A82478F31/L0/001",
//                           "E2AF7BA4-FC5C-434B-9F89-604DB7390C8E/L0/001",
//                           "192E5D25-37AB-4CF8-802C-7EC9118250F1/L0/001"]
        
        var identifiers: [String] = []
        for videoInfo in videoInfoArray {
            identifiers.append(videoInfo.videoLocalIdentifier)
        }
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: .none)
        
        for index in 0..<assets.count {
            guard (assets[index].mediaType == PHAssetMediaType.video)

                else {
                    print("Not a valid video media type")
                    return
            }
            
            var asset: AVURLAsset?
            PHCachingImageManager().requestAVAsset(forVideo: assets[index], options: nil) { (assets, audioMix, info) in
                asset = assets as? AVURLAsset
                
                DispatchQueue.main.async {
                    guard let url = asset?.url else {
                        print ("UUUUUUUU")
                        return }
                    var swipeCard = SwipeableCardVideoView(asset: AVAsset(url: url))
                    
                    if index == 0 {
                        swipeCard.embedVideo()
                        swipeCard.videoPlay()
                    }
                    
                    self.view.insertSubview(swipeCard, at: 0)
                    self.cards.append(swipeCard)
                    
                    swipeCard.snp.makeConstraints {
                        $0.center.equalToSuperview()
                        $0.height.equalTo(420.0)
                        $0.leading.trailing.equalToSuperview().inset(60.0)
                    }
                    
                    swipeCard.tag = index
                    print(swipeCard.tag)
                    self.view.sendSubviewToBack(self.emptyVideoView)
                    
                    // gesture
                    let gesture = UIPanGestureRecognizer()
                    gesture.addTarget(self, action: #selector(self.handlerCard))
                    swipeCard.addGestureRecognizer(gesture)
                }
            }
        }
    }

    // swipeCard가 SuperView에서 제거됩니다.
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
    
    
    
    // swipeCard의 애니매이션 효과를 담당합니다.
    func animateCard(rotationAngle: CGFloat, videoResultType: VideoResultType) {
        
        print(view.subviews.count)
        var cardViews = view.subviews.filter({ ($0 as? SwipeableCardVideoView) != nil })
        print("DDD ", cardViews.count)
        
        for view in cardViews {
            if view == cards[counter] {
                let center: CGPoint
                let isSuccess: Bool
                let  card = view as! SwipeableCardVideoView
                
                switch videoResultType {
                case .fail:
                    center = CGPoint(x: card.center.x - view.bounds.width, y: card.center.y + 30)
                    isSuccess = false
                    
                case .success:
                    center = CGPoint(x: card.center.x + view.bounds.width, y: card.center.y + 30)
                    isSuccess = true
                }
                
                UIView.animate(withDuration: 0.6, animations: {
                    card.center = center
                    card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                    card.successImageView.alpha = isSuccess == true ? 1 : 0
                    card.failImageView.alpha = isSuccess == false ? 1 : 0
                }) { [self] _ in
                    if counter != cards.count-1 {
                        print(counter)
                        cards[counter].videoPlay()
                        removeCard(card: card)
                        counter += 1
                    } else {
                        didVideoClassificationComplete()
                        removeCard(card: card)
                    }
                }
            }
        }
    }

    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
        print("pop 가 됐습니다.")
    }

    func didVideoClassificationComplete() {
        levelButton.isEnabled = false
        
        saveButton.isHidden = false
        successButton.isHidden = true
        failButton.isHidden = true
        
        titleLabel.text = "분류 완료! 저장하기를 눌러주세요."
        levelButton.setTitle("레벨", for: .normal)
        
        titleLabel.textColor = .orrGray3
        levelButton.tintColor = .orrGray3
        separator.backgroundColor = .orrGray3
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
