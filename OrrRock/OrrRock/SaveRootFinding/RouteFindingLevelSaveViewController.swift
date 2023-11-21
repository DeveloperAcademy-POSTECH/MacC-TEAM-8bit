//
//  RouteFindingLevelSaveViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/29.
//

import UIKit

import SnapKit
import Photos
import Then

final class RouteFindingLevelSaveViewController: UIViewController {
    
    var routeDataDraft: RouteDataDraft
    var backgroundImage: UIImage
    
    private var currentSelectedLevel = 0
    
    private lazy var exitButton: UIButton = .init().then {
        $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        $0.layer.cornerRadius = 20
        $0.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        $0.tintColor = .white
        $0.addAction(UIAction { _ in
            self.goBackAction()
        }, for: .touchUpInside)
    }
    
    let gymNameLabel : UILabel = {
        let label = UILabel()
        label.text = "난이도를 선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .orrBlack
        return label
    }()
    
    private lazy var newLevelPickerView: NewLevelPickerView = .init().then {
        $0.pickerSelectValue = 0
        $0.delegate = self
        $0.customTitle = "슬라이드 해주세요"
        
    }
    
    private lazy var levelButtonImage: UIImageView = .init().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = .orrGray500
    }
    
    let nextButton: UIButton = .init().then {
        $0.setBackgroundColor(.orrUPBlue!, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
    }
    
    init(routeDataDraft: RouteDataDraft, backgroundImage: UIImage) {
        self.routeDataDraft = routeDataDraft
        self.backgroundImage = backgroundImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orrWhite
        overrideUserInterfaceStyle = .dark
        
        setUpLayout()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc final func pressNextButton() {
        routeDataDraft.updateProblemLevel(problemLevel: currentSelectedLevel)
        
        var imageLocalIdentifier = routeDataDraft.routeInfoForUI.imageLocalIdentifier
        
        if  imageLocalIdentifier == "" {
            savePhotoByLocalIdentifier(targetImage: backgroundImage) { localIdentifier in
                self.routeDataDraft.routeInfoForUI.imageLocalIdentifier = localIdentifier
                self.routeDataDraft.save()
            }
        } else {
            // 사진 앨범에서 사진을 가져왔을 경우
            routeDataDraft.save()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RouteFindingLevelSaveViewController: NewLevelPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: Int) {
        currentSelectedLevel = selectedLevel
    }
    
}

private extension RouteFindingLevelSaveViewController {
    
    func setUpLayout() {
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        view.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(exitButton).offset(OrrPd.pd72.rawValue)
            $0.height.equalTo(26)
        }
        
        view.addSubview(newLevelPickerView)
        newLevelPickerView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(120)
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(OrrPd.pd36.rawValue)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).inset(OrrPd.pd36.rawValue)
            $0.leading.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
    }
    
}

private extension RouteFindingLevelSaveViewController {
    
    // 사진 촬영 기능을 통해 사진을 가져왔을 경우
    func savePhotoByLocalIdentifier(targetImage image: UIImage?, _ completion: @escaping (String) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            do {
                try PHPhotoLibrary.shared().performChangesAndWait {
                    guard let photoImage = image else { return }
                    let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                    completion(assetRequest.placeholderForCreatedAsset?.localIdentifier ?? "")
                }
            }
            catch let error {
                print("saveImage: there was a problem: \(error.localizedDescription)")
            }
        }
    }
    
}
