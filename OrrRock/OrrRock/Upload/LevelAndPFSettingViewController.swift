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
    
    // 오토레이아웃의 시작점이 되는 값입니다. 변경시 류하에게 문의 주세요.
    private let padding = 68
    
    var videoInfoArray: [VideoInfo] = []
    
    private var cards: [SwipeableCardVideoView?] = []
    private var counter: Int = 0
    private var currentSelectedLevel = 0
    private var selectedCard: Int = 0
    private var classifiedCard: Int = 0
    private var timeObserverToken: Any?
    private var firstCardtimeObserverToken: Any?
    
    private lazy var BackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        view.layer.zPosition = -1
        
        return view
    }()
    
    private lazy var newLevelPickerView: NewLevelPickerView = {
        let view = NewLevelPickerView()
        view.pickerSelectValue = 0
        view.delegate = self
        view.layer.zPosition = -1

        return view
    }()
    
    private lazy var levelButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .orrGray500
        
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
    
    private lazy var paddigView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var emptyVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray300
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var emptyVideoInformation: UILabel = {
        let label = UILabel()
        label.text = "모든 비디오를 분류했습니다!"
        label.textColor = .orrGray500
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        
        return label
    }()
    
    private lazy var failButton: CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(named: "fail_icon"), for: .normal)
        button.layer.cornerRadius = 37.0
        button.addTarget(self, action: #selector(didFailButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteButton: CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.layer.cornerRadius = 37.0
        button.addTarget(self, action: #selector(didDeleteButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var successButton: CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(named: "success_icon"), for: .normal)
        button.layer.cornerRadius = 37.0
        button.addTarget(self, action: #selector(didSuccessButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var videoSlider: VideoSlider = {
        let slider = VideoSlider()
        slider.minimumTrackTintColor = .orrUPBlue
        slider.maximumTrackTintColor = .orrGray100
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        // 재생시점 조정 제스처
        slider.addTarget(self, action: #selector(didChangedSlider(_:)), for: .valueChanged)
        
        // 탭 했을 때 일시정지 제스처
//        let touchesBeganGesture = UITapGestureRecognizer()
//        touchesBeganGesture.addTarget(self, action: #selector(self.didSliderTouchesBegin(slider)))
//
//        let touchesEndedGesture = UITapGestureRecognizer()
//        touchesBeganGesture.addTarget(self, action: #selector(self.didSliderTouchesEnded(slider)))
        
        slider.addTarget(self, action: #selector(didSliderTouchesBegin(_:)), for: .editingDidBegin)
        slider.addTarget(self, action: #selector(didSliderTouchesEnded(_:)), for: .editingDidEnd)
        
        return slider
    }()
    
    private lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.orrUPBlue!, for: .normal)
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        button.setTitle("완료", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10.0
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.isHidden = true
        
        return button
    }()
    
    private lazy var emptyBackgroundView: EmptyBackgroundView = {
        let view = EmptyBackgroundView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !UserDefaults.standard.bool(forKey: "SwipeOnboardingClear"){
            let nextVC = SwipeOnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
        
        view.backgroundColor = .orrWhite
        
        self.navigationController?.setExpansionBackbuttonArea()

        // card UI
        setUpLayout()
        
        createSwipeableCard() { [self] in
            self.cards.forEach { swipeCard in
                self.view.insertSubview(swipeCard!, at: 0)
                swipeCard!.snp.makeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.centerY.equalToSuperview()
                    $0.leading.equalTo(view.snp.leading).offset(padding)
                    $0.trailing.equalTo(view.snp.trailing).offset(-padding)
                    $0.height.equalTo(swipeCard!.snp.width).multipliedBy(1.641)
                }
                
                self.view.sendSubviewToBack(self.emptyVideoView)
                self.view.sendSubviewToBack(self.BackgroundView)
                
                // gesture
                let gesture = UIPanGestureRecognizer()
                gesture.addTarget(self, action: #selector(self.handlerCard))
                swipeCard!.addGestureRecognizer(gesture)
            }
            CustomIndicator.stopLoading()
        }
    }
}

// Slider
private extension LevelAndPFSettingViewController {
    
    // 비디오 재생 시간 변화에 따른 슬라이더 업데이트
    func updateVideoSlider(card: SwipeableCardVideoView, time currentTime: CMTime) {
        if let currentItem = card.queuePlayer.currentItem {
            let duration = currentItem.duration
            if CMTIME_IS_INVALID(duration) { return }
            videoSlider.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    
    // 슬라이더 터치에 따른 비디오 업데이트
    @objc
    func didChangedSlider(_ sender: UISlider) {
        let card = cards[counter]?.queuePlayer
        
        guard let duration = card?.currentItem?.duration else { return }
        let value = Float64(sender.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        card?.currentItem?.seek(to: seekTime)
    }
    
    @objc
    func didSliderTouchesBegin(_ sender: UISlider) {
        // TODO: 터치 시작
    }
    
    @objc
    func didSliderTouchesEnded(_ sender: UISlider) {
        // TODO: 터치 끝
    }
    
    func addPeriodicTimeObserver(card: SwipeableCardVideoView, isFirstCard: Bool){
        
        let interval = CMTime(seconds: 0.0001, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // time observer 생성 후 token에 저장
        switch isFirstCard{
        case true:
            firstCardtimeObserverToken = card.queuePlayer.addPeriodicTimeObserver(
                forInterval:interval,
                queue: DispatchQueue.main,
                using: { [weak self] currentTime in
                    self?.updateVideoSlider(card: card, time: currentTime)
                    // TODO: 남은 시간 표시
                    // self?.updateTimeRemaining(currentTime)
                })
        case false:
            timeObserverToken = card.queuePlayer.addPeriodicTimeObserver(
                forInterval:interval,
                queue: DispatchQueue.main,
                using: { [weak self] currentTime in
                    self?.updateVideoSlider(card: card, time: currentTime)
                    // TODO: 남은 시간 표시
                    // self?.updateTi meRemaining(currentTime)
                })
        }
    }
    
    func removePeriodicTimeObserver(card: SwipeableCardVideoView, isFirstCard: Bool){
        
        switch isFirstCard {
        case true:
            if let timeObserverToken = firstCardtimeObserverToken {
                card.queuePlayer.removeTimeObserver(timeObserverToken)
                self.firstCardtimeObserverToken = nil
            }
        case false:
            if let timeObserverToken = timeObserverToken {
                card.queuePlayer.removeTimeObserver(timeObserverToken)
                self.timeObserverToken = nil
            }
        }
    }
}

extension LevelAndPFSettingViewController: NewLevelPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: Int) {
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
        // 선택된 카드의 개수
        selectedCard = cards.count
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
                    let alert = UIAlertController(title: "영상을 불러올 수 없습니다.", message: "영상을 불러오는 데 오류가 발생하였습니다.\n\n영상의 포맷이 일반적이지 않은 영상일 수 있으니 확인 후 다시 업로드 해 주세요", preferredStyle: .alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.addAction(confirm)
                    
                    self.present(alert, animated: true) {
                        CustomIndicator.stopLoading()
                    }
                    return
                }
                
                // Main Thread에서 View를 디스패치 그룹
                DispatchQueue.main.async(group: countingGroup) { [self] in
                    
                    let swipeCard = SwipeableCardVideoView(asset: AVAsset(url: url))
                    
                    swipeCard.embedVideo()
                    
                    cards[index] = swipeCard
                    
                    // Asset 카운팅 -1
                    countingGroup.leave()
                    
                    // 분류된 카드 번호 넘버링
                    classifiedCard = index + 1
                    // '분류된 카드 / 선택된 카드' 형식의 문자열 값을 넘겨주는 메서드
                    swipeCard.getCardLabelText(labelText: "\(classifiedCard)/\(selectedCard)")
                }
                
                // Asset 카운팅이 0이 되었을 때 completionHandler로 반환
                countingGroup.notify(queue: DispatchQueue.main) {
                    if self.firstCardtimeObserverToken == nil {
                        let firstCard = self.cards[0] as? SwipeableCardVideoView
                        guard let card = firstCard else { return }
                        // 첫번째 Observer
                        self.addPeriodicTimeObserver(card: card, isFirstCard: true)
                        firstCard?.queuePlayer.play()
                    }
                    completion()
                }
            }
        }
    }
    
    // swipeCard가 SuperView에서 제거됩니다.
    @objc
    func removeCard(card: UIView) {
        card.removeFromSuperview()
        // 스와이프가 완료되고 removeCard가 호출될 때 버튼 활성화
        successButton.isEnabled = true
        failButton.isEnabled = true
        counter += 1
        
    }
    
    // Gesture
    @objc
    func handlerCard(_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view as? SwipeableCardVideoView {
            let point = gesture.translation(in: view)
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let horizonalRotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x > 0 {
                card.successImageView.alpha = horizonalRotationAngle * 5
                card.failImageView.alpha = 0
                card.setVideoBackgroundViewBorderColor(color: .pass, alpha: horizonalRotationAngle * 5)
            } else {
                card.successImageView.alpha = 0
                card.failImageView.alpha = -horizonalRotationAngle * 5
                card.setVideoBackgroundViewBorderColor(color: .fail, alpha: -horizonalRotationAngle * 5)
            }
            
            card.transform = CGAffineTransform(rotationAngle: horizonalRotationAngle)
            
            if gesture.state == .ended {
                // 카드의 x축을 통한 성패 결정 스와이프 정도
                
                let cardPositionX = card.center.x
                
                switch cardPositionX {
                case self.view.bounds.width / 3 * 2..<self.view.bounds.width:
                    animateCard(rotationAngle: horizonalRotationAngle, videoResultType: .success)
                    return
                case 0..<self.view.bounds.width / 3:
                    animateCard(rotationAngle: horizonalRotationAngle, videoResultType: .fail)
                    return
                default:
                    card.center = self.emptyVideoView.center
                    card.transform = .identity
                    card.successImageView.alpha = 0
                    card.failImageView.alpha = 0
                    card.setVideoBackgroundViewBorderColor(color: .clear, alpha: 1)
                    return
                }
                
                // TODO: - 영상 삭제 제스처
            }
        }
    }
    
    // 실패 버튼을 눌렀을 때 로직
    @objc
    func didFailButton() {
        animateCard(rotationAngle: -0.4, videoResultType: .fail)
        failButton.isActivated.toggle()
    }
    
    // 삭제 버튼을 눌렀을 때 로직
    @objc
    func didDeleteButton() {
        animateCard(rotationAngle: 0, videoResultType: .delete)
    }
    
    // 성공 버튼을 눌렀을 때 로직
    @objc
    func didSuccessButton() {
        animateCard(rotationAngle: 0.4, videoResultType: .success)
        successButton.isActivated.toggle()
    }
    
    // 다음 뷰로 넘어가는 로직
    @objc
    func tapSaveButton() {
        DataManager.shared.createMultipleData(infoList: videoInfoArray.filter{ $0.isDeleted == false })
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // swipeCard의 애니메이션 효과를 담당합니다.
    func animateCard(rotationAngle: CGFloat, videoResultType: VideoResultType) {
        
        guard let card = cards[counter] else { return }
        removePeriodicTimeObserver(card: card, isFirstCard:  counter == 0 ? true : false)
        
        let cardViews = view.subviews.filter({ ($0 as? SwipeableCardVideoView) != nil })
        
        for view in cardViews {
            
            if view == cards[counter] {
                let center: CGPoint
                let isSuccess: Bool
                let isDeleted: Bool
                let card = view as! SwipeableCardVideoView
                
                // 마지막 카드가 아닐 때 다음 카드를 재생
                if counter != cards.count-1 {
                    
                    // 다음에 나올 카드
                    guard let nextCard = cards[counter + 1] as? SwipeableCardVideoView else { return }
                    // Slider에 시간 정보를 업데이트하기 위한 Observer 추가
                    addPeriodicTimeObserver(card: nextCard, isFirstCard: false)
                    // 이전 카드가 스와이프가 되었을 때 다음에 나올 카드가 재생
                    nextCard.queuePlayer.play()
                }
                
                // TODO: case 분기 개선 필요
                switch videoResultType {
                case .fail:
                    center = CGPoint(x: card.center.x - view.bounds.width, y: card.center.y + 30)
                    isSuccess = false
                    isDeleted = false
                case .success:
                    center = CGPoint(x: card.center.x + view.bounds.width, y: card.center.y + 30)
                    isSuccess = true
                    isDeleted = false
                case .delete:
                    center = CGPoint(x: card.center.x, y: card.center.y - view.bounds.height)
                    isSuccess = false
                    isDeleted = true
                }
                
                if isDeleted {
                    videoInfoArray[counter].isDeleted = true
                } else {
                    // 성공이나 실패로 분류되면 성패 여부와 레벨 정보 저장
                    videoInfoArray[counter].isSucceeded = isSuccess
                    videoInfoArray[counter].problemLevel = currentSelectedLevel ?? 0
                }
                
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        
                        card.center = center
                        card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                        
                        if !isDeleted{
                            card.successImageView.alpha = isSuccess == true ? 1 : 0
                            card.failImageView.alpha = isSuccess == false ? 1 : 0
                            card.setVideoBackgroundViewBorderColor(color: isSuccess ? .pass : .fail, alpha: 1)
                        } else {
                            // 카드 삭제시 애니메이션
                            // TODO: 삭제 라벨 alpha
                            // TODO: 삭제 보더 alpha
                            card.setVideoBackgroundViewBorderColor(color: .delete, alpha: 1)
                        }
                        // 카드 스와이프 애니매이션이 진행 중일 때 버튼 비활성화
                        self.successButton.isEnabled = false
                        self.failButton.isEnabled = false
                        
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
    
    // 모든 카드를 스와이핑 했을 때 호출되는 메서드
    // MARK: RuyHa
    func didVideoClassificationComplete() {
        // 한번 더 제거해주는 로직
        cards.removeAll()
        saveButton.isHidden = false
        successButton.isHidden = true
        failButton.isHidden = true
        deleteButton.isHidden = true
        videoSlider.isHidden = true
        buttonStackView.isUserInteractionEnabled = false
    }
}

private extension LevelAndPFSettingViewController {
    
    func setUpLayout() {
        
        view.addSubview(BackgroundView)
        BackgroundView.snp.makeConstraints {
            $0.center.equalTo(view.center)
            $0.height.equalTo(view.snp.height)
            $0.width.equalTo(view.snp.width)
            BackgroundView.setUpLayout()
        }
        
        view.addSubview(emptyVideoView)
        emptyVideoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(view.snp.leading).offset(padding)
            $0.trailing.equalTo(view.snp.trailing).offset(-padding)
            $0.height.equalTo(emptyVideoView.snp.width).multipliedBy(1.641)
        }
        
        
        view.addSubview(newLevelPickerView)
        newLevelPickerView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(emptyVideoView.snp.top).offset(-OrrPd.pd16.rawValue)
        }
        
        emptyVideoView.addSubview(emptyVideoInformation)
        emptyVideoInformation.snp.makeConstraints {
            $0.center.equalTo(emptyVideoView.snp.center)
        }
        
        // TODO: Slider가 너무 빨리 그려지는 이슈
        view.addSubview(videoSlider)
        videoSlider.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(OrrPd.pd16.rawValue)
            // TODO: Slider 초기, 후기에 급하게 값이 변동되어 offset으로 해당 영역 숨김. 슬라이더 디테일 작업 보완 예정.
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd24.rawValue)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(OrrPd.pd24.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(paddigView)
        paddigView.snp.makeConstraints {
            $0.top.equalTo(emptyVideoView.snp.bottom)
            $0.bottom.equalTo(videoSlider.snp.top)
            $0.leading.equalTo(emptyVideoView.snp.leading)
            $0.trailing.equalTo(emptyVideoView.snp.trailing)
        }
        
        paddigView.addSubview(failButton)
        failButton.snp.makeConstraints {
            $0.centerY.equalTo(paddigView.snp.centerY).multipliedBy(0.9)
            $0.leading.equalTo(view.snp.leading).offset(padding / 2)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        paddigView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(paddigView.snp.centerY).multipliedBy(0.9)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        paddigView.addSubview(successButton)
        successButton.snp.makeConstraints {
            $0.centerY.equalTo(paddigView.snp.centerY).multipliedBy(0.9)
            $0.trailing.equalTo(view.snp.trailing).offset(-padding / 2)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd16.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
    }
}
