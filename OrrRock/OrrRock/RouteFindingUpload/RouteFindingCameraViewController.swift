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

    private var currentLocalIdentifier: String?
    
    private lazy var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
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
    }
  
    func setUpLayout() {
        
        let shutterButtonSize: CGFloat = 75
        let safeArea = view.safeAreaLayoutGuide
        let height: CGFloat = UIScreen.main.bounds.width * 16/9
        view.addSubview(videoView)
        videoView.snp.makeConstraints({
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

extension RouteFindingCameraViewController {
    @objc func showPhotoPicker() {
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func fetchLastPhoto(fetchResult: PHFetchResult<PHAsset>) -> UIImage? {
        
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
    
    func setPhotosButtonImage() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            let image = fetchLastPhoto(fetchResult: fetchResult)
            photosButton.setImage(image, for: .normal)
        }
        
    }
}

extension RouteFindingCameraViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let provider = results.first?.itemProvider else {return}
        
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        currentLocalIdentifier = fetchResult[0].localIdentifier

        provider.loadFileRepresentation(forTypeIdentifier: "public.image") { url, error in
            guard error == nil else {
                print(error as Any)
                return
            }
        }
        dismiss(animated: true)
    }
}
