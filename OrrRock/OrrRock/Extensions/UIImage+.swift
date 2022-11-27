//
//  UIImage+.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/23.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    // https://stackoverflow.com/questions/158914/cropping-an-uiimage
    func cropped(rect: CGRect) -> UIImage? {
            if let image = self.cgImage!.cropping(to: rect) {
                return UIImage(cgImage: image)
            } else if let image = (self.ciImage)?.cropped(to: rect) {
                return UIImage(ciImage: image)
            }
           return nil
       }
        if let image = self.cgImage!.cropping(to: rect) {
            return UIImage(cgImage: image)
        } else if let image = (self.ciImage)?.cropped(to: rect) {
            return UIImage(ciImage: image)
        }
        return nil
    }
    
    // https://github.com/Juhwa-Lee1023/SolDoKu/blob/main/Sudoku/Extensions/UIImage%2B.swift
    func fixOrientation() -> UIImage {
        
        // 이미지의 방향이 올바를 경우 수정하지 않는다.
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        // 이미지를 변환시키기 위한 함수 선언
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        // 이미지의 상태에 맞게 이미지를 돌린다.
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        } else if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        } else if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        } else if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        // 이미지 변환용 값 선언
        let cgValue: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                           bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                           space: self.cgImage!.colorSpace!,
                                           bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        cgValue.concatenate(transform)
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
             self.imageOrientation == UIImage.Orientation.leftMirrored ||
             self.imageOrientation == UIImage.Orientation.right ||
             self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            cgValue.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        } else {
            cgValue.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        return UIImage(cgImage: cgValue.makeImage()!)
    }
    
}
