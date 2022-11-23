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
}
