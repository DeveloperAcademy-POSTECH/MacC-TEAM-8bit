//
//  CameraView.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/28.
//

import UIKit
import AVFoundation

final class CameraView: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }
    
}
