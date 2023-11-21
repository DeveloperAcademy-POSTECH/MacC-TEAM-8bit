//
//  RouteFindingCameraViewController+AVCapturePhotoCaptureDelegate.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/28.
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
