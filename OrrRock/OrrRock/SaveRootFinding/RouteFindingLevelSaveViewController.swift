//
//  RouteFindingLevelSaveViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/29.
//

import UIKit

import SnapKit
import Photos

final class RouteFindingLevelSaveViewController: UIViewController {
    
    var routeDataDraft: RouteDataDraft
    var backgroundImage: UIImage
    
    private var currentSelectedLevel = 0
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        button.tintColor = .white
        button.addAction(UIAction { _ in
            self.goBackAction()
        }, for: .touchUpInside)
        
        return button
    }()
    
    let gymNameLabel : UILabel = {
        let label = UILabel()
        label.text = "난이도를 선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .orrBlack
        return label
    }()
    
    private lazy var newLevelPickerView: NewLevelPickerView = {
        let view = NewLevelPickerView()
        view.pickerSelectValue = 0
        view.delegate = self
        view.customTitle = "슬라이드 해주세요"
        
        return view
    }()
    
    private lazy var levelButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .orrGray500
        
        return imageView
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.orrUPBlue!, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
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
