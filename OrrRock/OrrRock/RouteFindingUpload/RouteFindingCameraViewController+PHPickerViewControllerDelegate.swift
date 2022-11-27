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

        provider.loadFileRepresentation(forTypeIdentifier: "public.image") { url, error in
            guard error == nil else {
                print(error as Any)
                return
            }
        }
        
        dismiss(animated: true)
    }
}
