//
//  RouteFindingCameraViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/25.
//

import UIKit
import SnapKit
import PhotosUI

class RouteFindingCameraViewController: UIViewController {
    
    var currentLocalIdentifier: String?
    
    private lazy var cameraView: CameraView = {
        let view = CameraView()
        
        return view
    }()
    
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var photoOutput: AVCapturePhotoOutput!
    private var cameraAuthorizeStatus = CameraSessionStatus.success
    
    var photoImage: UIImage? = nil
    var photoData: Data? = nil
    
    private lazy var photosButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orrGray900?.cgColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(showPhotoPicker), for: .touchUpInside)
        return button
    }()
    
    private lazy var shutterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.orrWhite?.cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 37.5
        
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "000000").withAlphaComponent(0.3)
        button.layer.borderColor = UIColor(hex: "979797").cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .small)
        let buttonSymbol = UIImage(systemName: "multiply", withConfiguration: config)?.withTintColor(UIColor.orrWhite ?? UIColor.white, renderingMode: .alwaysOriginal)
        button.setImage(buttonSymbol, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setPhotosButtonImage()
        
        setCameraPreviewLayer()
        authorizateCameraStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photoImage = nil
        photoData = nil
        currentLocalIdentifier = nil
        
        executeCameraSession()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPhotosButtonImage), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if cameraAuthorizeStatus == .success {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}

// MARK: Layout Function
private extension RouteFindingCameraViewController {
    func setUpLayout() {
        
        let shutterButtonSize: CGFloat = 75
        let safeArea = view.safeAreaLayoutGuide
        let height: CGFloat = UIScreen.main.bounds.width * 16/9
        view.addSubview(cameraView)
        cameraView.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(height)
        })
        
        view.addSubview(shutterButton)
        shutterButton.snp.makeConstraints({
            $0.bottom.equalTo(safeArea.snp.bottom).inset(OrrPd.pd16.rawValue)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.width.height.equalTo(shutterButtonSize)
        })
        
        let circleLayer = CAShapeLayer()
        let circleSize: CGFloat = 57
        let circleShape = UIBezierPath(ovalIn: CGRect(x: (shutterButtonSize - circleSize)/2, y: (shutterButtonSize - circleSize)/2, width: circleSize, height: circleSize))
        circleLayer.path = circleShape.cgPath
        circleLayer.fillColor = UIColor.orrWhite?.cgColor
        shutterButton.layer.addSublayer(circleLayer)
        
        view.addSubview(photosButton)
        photosButton.snp.makeConstraints({
            $0.leading.equalTo(safeArea.snp.leading).inset(OrrPd.pd16.rawValue)
            $0.centerY.equalTo(shutterButton.snp.centerY)
            $0.width.height.equalTo(shutterButtonSize)
        })
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints({
            $0.leading.equalTo(safeArea.snp.leading).offset(OrrPd.pd16.rawValue)
            $0.top.equalTo(safeArea.snp.top).offset(OrrPd.pd16.rawValue)
            $0.width.height.equalTo(40)
        })
    }
}

// MARK: Button Objc Functions Extension
private extension RouteFindingCameraViewController {
    
    @objc private func showPhotoPicker() {
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        captureSession.stopRunning()
    }
    
    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        sessionQueue.async {
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }
}

// MARK: Photos Button Image Setting Extension
private extension RouteFindingCameraViewController {
    @objc private func setPhotosButtonImage() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            let image = fetchLastPhoto(fetchResult: fetchResult)
            photosButton.setImage(image, for: .normal)
        }
    }
    
    private func fetchLastPhoto(fetchResult: PHFetchResult<PHAsset>) -> UIImage? {
        
        var resultImage: UIImage = UIImage()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        PHImageManager.default().requestImage(for: fetchResult.object(at: 0) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                let width = image.size.width
                let height = image.size.height
                let croppedImage = image.cropped(rect: CGRect(x: 0, y: (height - width)/2, width: width, height: width))
                resultImage = croppedImage ?? UIImage()
                
            }
        })
        return resultImage
    }
}

// MARK: Camera Session Setting Extension
private extension RouteFindingCameraViewController {
    private func authorizateCameraStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.cameraAuthorizeStatus = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        default:
            cameraAuthorizeStatus = .notAuthorized
        }
    }
    
    private func setCameraPreviewLayer() {
        cameraView.videoPreviewLayer.session = captureSession
        cameraView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    private func setupCaptureSession() {
        sessionQueue.async { [self] in
            captureSession.beginConfiguration()
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                      for: .video, position: .unspecified)
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
                  captureSession.canAddInput(videoDeviceInput) else { return }
            captureSession.addInput(videoDeviceInput)
            
            photoOutput = AVCapturePhotoOutput()
            guard captureSession.canAddOutput(photoOutput) else { return }
            captureSession.sessionPreset = .photo
            captureSession.addOutput(photoOutput)
            
            DispatchQueue.main.async {
                var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
                if let videoOrientation = AVCaptureVideoOrientation(rawValue: UIInterfaceOrientation.portrait.rawValue) {
                    initialVideoOrientation = videoOrientation
                }
                
                self.cameraView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
            }
            captureSession.commitConfiguration()
        }
    }
    
    private func executeCameraSession() {
        sessionQueue.async { [self] in
            switch cameraAuthorizeStatus {
            case .success:
                captureSession.startRunning()
            case .notAuthorized:
                showAuthAlert()
                break
            case .configurationFailed:
                break
            }
        }
    }
    
    private func showAuthAlert() {
        DispatchQueue.main.async {
            let alertMessage = "클라이밍 문제 촬영을 위해 카메라 사용 권한이 필요합니다.\n[설정] > [개인 정보 보호] > [카메라]에서 권한을 설정해주세요."
            let message = NSLocalizedString(alertMessage, comment: "")
            let alertController = UIAlertController(title: "ORRROCK", message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: ""),
                                                    style: .cancel,
                                                    handler: nil))
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("설정", comment: ""),
                                                    style: .`default`,
                                                    handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                          options: [:],
                                          completionHandler: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
