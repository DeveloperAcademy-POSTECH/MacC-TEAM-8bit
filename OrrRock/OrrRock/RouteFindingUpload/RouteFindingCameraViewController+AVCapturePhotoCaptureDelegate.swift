//
//  RouteFindingCameraViewController+AVCapturePhotoCaptureDelegate.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/28.
//

import UIKit
import AVFoundation
import Photos

extension RouteFindingCameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let data = photo.fileDataRepresentation() else { return }
        
        let orientationFixedImage = UIImage(data: data)?.fixOrientation() ?? UIImage()
        let rect = orientationFixedImage.imageRectAs16to9()
        
        photoImage = orientationFixedImage.cropped(rect: rect)
        photoData = photoImage?.pngData()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
        guard error == nil else {
            print("Error capturing photo: \(error)")
            return
        }
        
        // MARK: Photo Save - 데이터 플로우에 따라 추후 RouteFinding 마지막 과정에서 호출될 가능성이 존재합니다.
        PHPhotoLibrary.requestAuthorization({ status in
            if status == .authorized {
                // https://stackoverflow.com/questions/65545089/get-phasset-localidentifier-of-image-saved-to-photo-library
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        guard let photoImage = self.photoImage else { return }
                        let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                        self.currentLocalIdentifier = assetRequest.placeholderForCreatedAsset?.localIdentifier
                    }
                }
                catch let error {
                    print("saveImage: there was a problem: \(error.localizedDescription)")
                }
            }
        })
        
        navigateToRouteFindingFeatureVC(phAssetLocalIdentifier: "", image: photoImage)
    }
}
