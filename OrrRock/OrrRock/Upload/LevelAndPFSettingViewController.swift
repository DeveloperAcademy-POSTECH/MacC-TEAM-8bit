//
//  LevelAndPFSettingViewController.swift
//  OrrRock
//
//  Created by 이성노, Yeni Hwang on 2022/10/21.
//

import UIKit

import AVFoundation
import AVKit
import SnapKit
import Photos

final class LevelAndPFSettingViewController: UIViewController {
    
    var videoInfoArray: [VideoInfo] = []
    
    private var cards: [SwipeableCardVideoView?] = []
    private var counter: Int = 0
    private var currentSelectedLevel = -1
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.layer.zPosition = -1
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스와이프를 통해 비디오를 분류해주세요."
        label.textColor = .orrBlack
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.text = "레벨"
        label.textColor = .orrBlack
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var levelButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택안함", for: .normal)
        button.setTitleColor(.black, for: .normal)
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
    
    private lazy var levelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        
        return stackView
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .orrBlack
        
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
    
    private lazy var failButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("실패", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        button.backgroundColor = .orrFail
        button.layer.cornerRadius = 37.0
        button.addTarget(self, action: #selector(didFailButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var successButton: CustomButton = {
        let button = CustomButton()
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
        
        view.backgroundColor = .orrWhite
        
        navigationItem.leftBarButtonItem = CustomBackBarButtomItem(target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = .orrUPBlue
        
        // card UI
        setUpLayout()
        
        createSwipeableCard() {
            self.cards.forEach { swipeCard in
                // FIXME: 다시 수정해야 되는 코드
                // 카드를 z축 기준 가장 상단에 위치하게 하는 코드
                // self.view.bringSubviewToFront(swipeCard!)
                self.view.insertSubview(swipeCard!, at: 0)
                swipeCard!.snp.makeConstraints {
                    $0.top.equalTo(self.emptyVideoView.snp.top)
                    $0.bottom.equalTo(self.emptyVideoView.snp.bottom)
                    $0.leading.equalTo(self.emptyVideoView.snp.leading)
                    $0.trailing.equalTo(self.emptyVideoView.snp.trailing)
                }
                
                self.view.sendSubviewToBack(self.emptyVideoView)
                
                // gesture
                let gesture = UIPanGestureRecognizer()
                gesture.addTarget(self, action: #selector(self.handlerCard))
                swipeCard!.addGestureRecognizer(gesture)
            }
            CustomIndicator.stopLoading()
        }
    }
}

extension LevelAndPFSettingViewController: LevelPickerViewDelegate {
    func setSeparatorColor() {
        self.separator.backgroundColor = .orrBlack
    }
    
    func didLevelChanged(selectedLevel: Int) {
        let levelButtonTiltle = selectedLevel == -1 ? "선택안함" : "V\(selectedLevel)"
        levelButton.setTitle(levelButtonTiltle, for: .normal)
        currentSelectedLevel = selectedLevel
    }
}

// Gesture
private extension LevelAndPFSettingViewController {
    
    // 목업용 카드를 만들어줍니다.
    func createSwipeableCard(_ completion: @escaping () -> Void) {
        
        var identifiers: [String] = []
        for videoInfo in videoInfoArray {
            identifiers.append(videoInfo.videoLocalIdentifier)
        }
        
        // 날짜 기준으로 정렬하는 PHFetchOptions 설정
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        // identifiers를 기반으로 불러온 PHAsset을 PHFetchResult<PHAsset> 타입으로 변환
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: option)
        // PHFetchResult<PHAsset>의 Asset 개수만큼 배열 공간 할당
        cards = Array(repeating: nil, count: assets.count)
        // Asset 카운팅을 위한 디스패치 그룹
        let countingGroup = DispatchGroup()
        
        CustomIndicator.startLoading()
        
        for index in 0..<assets.count {
            
            // Asset 카운팅 +1
            countingGroup.enter()
            
            // 미디어가 존재하는지 확인하는 코드
            guard (assets[index].mediaType == PHAssetMediaType.video)
            else {
                print("비디오 미디어가 존재하지 않습니다.")
                return
            }
            
            // 클라우드에서 Asset을 받아올 일이 생겼을 때 나는 오류 해결을 위한 PHVideoRequestOptions 설정
            let option = PHVideoRequestOptions()
            option.isNetworkAccessAllowed = true
            
            PHImageManager().requestAVAsset(forVideo: assets[index], options: option) { (assets, audioMix, info) in
                
                let asset = assets as? AVURLAsset
                
                guard let url = asset?.url else {
                    // 영상이 불러와지지 않을 시 경고창과 함께 뒤로 돌아가는 로직
                    let alret = UIAlertController(title: "영상을 불러올 수 없습니다.", message: "영상을 불러오는 데 오류가 발생하였습니다.\n\n영상의 포맷이 일반적이지 않은 영상일 수 있으니 확인 후 다시 업로드 해 주세요", preferredStyle: .alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alret.addAction(confirm)
                    
                    self.present(alret, animated: true) {
                        CustomIndicator.stopLoading()
                    }
                    return
                }
                
                // Main Thread에서 View를 디스패치 그룹
                DispatchQueue.main.async(group: countingGroup) {
                    
                    let swipeCard = SwipeableCardVideoView(asset: AVAsset(url: url))
                    
                    swipeCard.embedVideo()
                    
                    self.cards[index] = swipeCard
                    
                    // Asset 카운팅 -1
                    countingGroup.leave()
                    
                    // 첫번째 카드를 재생시켜주는 코드
                    let firstCard = self.cards[0] as? SwipeableCardVideoView
                    firstCard?.queuePlayer.play()
                }
                // Asset 카운팅이 0이 되었을 때 completionHandler로 반환
                countingGroup.notify(queue: DispatchQueue.main) {
                    completion()
                }
            }
        }
    }
    
    // swipeCard가 SuperView에서 제거됩니다.
    @objc func removeCard(card: UIView) {
        card.removeFromSuperview()
        // 스와이프가 완료되고 removeCard가 호출될 때 버튼 활성화
        successButton.isEnabled = true
        failButton.isEnabled = true
        // 카드가 사라질 때 카운팅
        counter += 1
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
                card.setVideoBackgroundViewBorderColor(color: .pass, alpha: rotationAngle * 5)
            } else {
                card.successImageView.alpha = 0
                card.failImageView.alpha = -rotationAngle * 5
                card.setVideoBackgroundViewBorderColor(color: .fail, alpha: -rotationAngle * 5)
            }
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            if gesture.state == .ended {
                // 카드의 x축을 통한 성패 결정 스와이프 정도
                if card.center.x > self.view.bounds.width - 30 {
                    animateCard(rotationAngle: rotationAngle, videoResultType: .success)
                    return
                }
                if card.center.x < 30 {
                    animateCard(rotationAngle: rotationAngle, videoResultType: .fail)
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    card.center = self.emptyVideoView.center
                    card.transform = .identity
                    card.successImageView.alpha = 0
                    card.failImageView.alpha = 0
                    card.setVideoBackgroundViewBorderColor(color: .clear, alpha: 1)
                    // 터치가 해제되고 카드가 돌아가는 도중에 터치 제한
                    UIApplication.shared.beginIgnoringInteractionEvents()
                } completion: {_ in
                    // completion을 통해 애니메이션이 끝났을 때 터치 제한 해제
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    
    @objc func pickLevel() {
        let nextViewController = LevelPickerView()
        nextViewController.pickerSelectValue = currentSelectedLevel + 1
        self.navigationController?.present(nextViewController, animated: true)
        separator.backgroundColor = .orrUPBlue
        nextViewController.delegate = self
    }
    
    // 실패 버튼을 눌렀을 때 로직
    @objc func didFailButton() {
        animateCard(rotationAngle: -0.4, videoResultType: .fail)
        failButton.isActivated.toggle()
    }
    
    // 성공 버튼을 눌렀을 때 로직
    @objc func didSuccessButton() {
        animateCard(rotationAngle: 0.4, videoResultType: .success)
        successButton.isActivated.toggle()
    }
    
    // 다음 뷰로 넘어가는 로직
    @objc func tapSaveButton() {
        DataManager.shared.createMultipleData(infoList: videoInfoArray)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // swipeCard의 애니매이션 효과를 담당합니다.
    func animateCard(rotationAngle: CGFloat, videoResultType: VideoResultType) {
        let cardViews = view.subviews.filter({ ($0 as? SwipeableCardVideoView) != nil })
        
        for view in cardViews {
            if view == cards[counter] {
                let center: CGPoint
                let isSuccess: Bool
                let card = view as! SwipeableCardVideoView
                
                // 마지막 카드가 아닐 때 다음 카드를 재생
                if counter != cards.count-1 {
                    // 다음에 나올 카드
                    guard let nextCard = cards[counter + 1] as? SwipeableCardVideoView else { return }
                    // 이전 카드가 스와이프가 되었을 때 다음에 나올 카드가 재생
                    nextCard.queuePlayer.play()
                }
                
                switch videoResultType {
                case .fail:
                    center = CGPoint(x: card.center.x - view.bounds.width, y: card.center.y + 30)
                    isSuccess = false
                    
                case .success:
                    center = CGPoint(x: card.center.x + view.bounds.width, y: card.center.y + 30)
                    isSuccess = true
                }
                
                videoInfoArray[counter].isSucceeded = isSuccess
                videoInfoArray[counter].problemLevel = currentSelectedLevel ?? 0
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = center
                    card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                    card.successImageView.alpha = isSuccess == true ? 1 : 0
                    card.failImageView.alpha = isSuccess == false ? 1 : 0
                    // 카드 스와이프 애니매이션이 진행 중일 때 버튼 비활성화
                    self.successButton.isEnabled = false
                    self.failButton.isEnabled = false
                    
                    if isSuccess{
                        card.setVideoBackgroundViewBorderColor(color: .pass, alpha: 1)
                    } else {
                        card.setVideoBackgroundViewBorderColor(color: .fail, alpha: 1)
                    }
                    
                }) { [self] _ in
                    if counter != cards.count-1 {
                        removeCard(card: card)
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
    }
    
    // 모든 카드를 스와이핑 했을 때 호출되는 메서드
    func didVideoClassificationComplete() {
        levelButton.isEnabled = false
        
        saveButton.isHidden = false
        successButton.isHidden = true
        failButton.isHidden = true
        
        titleLabel.text = "분류 완료! 저장하기를 눌러주세요."
        buttonStackView.isUserInteractionEnabled = false
        
        titleLabel.textColor = .orrGray3
        levelButton.tintColor = .orrGray3
    }
}

private extension LevelAndPFSettingViewController {
    
    func setUpLayout() {
        
        [levelButton, levelButtonImage].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        
        [levelLabel, buttonStackView].forEach {
            self.levelStackView.addArrangedSubview($0)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickLevel))
        buttonStackView.isUserInteractionEnabled = true
        buttonStackView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(headerView.snp.centerX)
            $0.top.equalTo(headerView.snp.top)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.width.equalTo(90.0)
        }
        
        headerView.addSubview(levelStackView)
        levelStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(OrrPadding.padding3.rawValue)
            $0.centerX.equalToSuperview()
        }
        
        levelButtonImage.snp.makeConstraints {
            $0.height.equalTo(20.0)
            $0.width.equalTo(20.0)
        }
        
        headerView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.centerX.equalTo(buttonStackView.snp.centerX)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(8.0)
            $0.bottom.equalTo(headerView.snp.bottom)
            $0.height.equalTo(2.0)
            $0.width.equalTo(90.0)
        }
        
        view.addSubview(failButton)
        failButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPadding.padding3.rawValue)
            $0.leading.equalToSuperview().inset(48.0)
            $0.height.equalTo(74.0)
            $0.width.equalTo(74.0)
        }
        
        view.addSubview(successButton)
        successButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPadding.padding3.rawValue)
            $0.trailing.equalToSuperview().inset(48.0)
            $0.height.equalTo(74.0)
            $0.width.equalTo(74.0)
        }
        
        view.addSubview(emptyVideoView)
        emptyVideoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(separator.snp.bottom).offset(OrrPadding.padding4.rawValue)
            $0.bottom.equalTo(successButton.snp.top).offset(-OrrPadding.padding4.rawValue)
            $0.width.equalTo(emptyVideoView.snp.height).multipliedBy(0.5625)
        }
        
        emptyVideoView.addSubview(emptyVideoInformation)
        emptyVideoInformation.snp.makeConstraints {
            $0.center.equalTo(emptyVideoView.snp.center)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPadding.padding3.rawValue)
            $0.leading.equalTo(view).offset(OrrPadding.padding3.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPadding.padding3.rawValue)
            $0.height.equalTo(56)
        }
    }
}
