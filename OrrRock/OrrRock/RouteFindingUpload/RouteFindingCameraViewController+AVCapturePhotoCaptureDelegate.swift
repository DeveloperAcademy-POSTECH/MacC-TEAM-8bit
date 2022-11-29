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

        navigateToRouteFindingFeatureVC(phAssetLocalIdentifier: "", image: photoImage)
    }
}

// MARK: Photo Save - 변경된 데이터 플로우에 따라 RouteFinding 마지막 과정에서 호출됩니다.
//func savePhotoByLocalIdentifier(targetImage image: UIImage?, _ completion: @escaping (String) -> Void) {
//    let status = PHPhotoLibrary.authorizationStatus()
//    if status == .authorized {
//        do {
//            try PHPhotoLibrary.shared().performChangesAndWait {
//                guard let photoImage = image else { return }
//                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
//                completion(assetRequest.placeholderForCreatedAsset?.localIdentifier ?? "")
//            }
//        }
//        catch let error {
//            print("saveImage: there was a problem: \(error.localizedDescription)")
//        }
//    }
//}

// savePhotoByLocalIdentifier 실제 사용 예시
//savePhotoByLocalIdentifier(targetImage: photoImage) { localIdentifier in
//    self.currentLocalIdentifier = localIdentifier
//    print(self.currentLocalIdentifier)
//}

