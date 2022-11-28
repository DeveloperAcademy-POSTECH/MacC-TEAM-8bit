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
        
        if let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil).firstObject {
            PHImageManager.default().requestImageDataAndOrientation(for: phAsset, options: nil) { [self] data, _, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    photoImage = image
                    
                    // MARK: **TEST** 이미지 넘김 테스트용 코드
                    guard let image = photoImage else { return }
                    navigateToSampleImageVC(image: image)
                }
            }
        }
        dismiss(animated: true)
    }
}
