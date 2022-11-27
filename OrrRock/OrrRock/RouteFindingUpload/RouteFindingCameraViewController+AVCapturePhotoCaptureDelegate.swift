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
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        } else {
            guard let data = photo.fileDataRepresentation() else { return }
            
            let orientationFixedImage = UIImage(data: data)?.fixOrientation() ?? UIImage()
            let rect = orientationFixedImage.imageRectAs16to9()
            
            photoImage = orientationFixedImage.cropped(rect: rect)
            photoData = photoImage?.pngData()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }

        PHPhotoLibrary.requestAuthorization({ status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    guard let photoData = self.photoData else { return }
                    creationRequest.addResource(with: .photo, data: photoData as Data, options: options)
                }, completionHandler: { _, error in
                    if let error = error {
                        print("Error occurred while saving photo to photo library: \(error)")
                    }
                })
            }
        })
    }
}
