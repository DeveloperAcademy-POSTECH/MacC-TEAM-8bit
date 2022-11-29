//
//  RouteFindingCameraViewController+PHPickerViewControllerDelegate.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/28.
//

import UIKit
import PhotosUI

extension RouteFindingCameraViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let provider = results.first?.itemProvider else { return }
        
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        currentLocalIdentifier = fetchResult[0].localIdentifier
        
        guard let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil).firstObject else { return }
        
        let imageRequestOption = PHImageRequestOptions()
        imageRequestOption.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImageDataAndOrientation(for: phAsset, options: imageRequestOption) { [self] data, _, _, _ in
            if let data = data, let image = UIImage(data: data) {
                
                let orientationFixedImage = image.fixOrientation()
                let rect = orientationFixedImage.imageRectAs16to9()
                
                photoImage = orientationFixedImage.cropped(rect: rect)
                
                // MARK: **TEST** 이미지 넘김 테스트용 코드
                guard let image = photoImage else { return }
                navigateToSampleImageVC(image: image)
            }
        }
        dismiss(animated: true)
    }
}
