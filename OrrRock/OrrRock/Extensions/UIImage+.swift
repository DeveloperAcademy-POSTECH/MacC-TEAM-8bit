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
}
