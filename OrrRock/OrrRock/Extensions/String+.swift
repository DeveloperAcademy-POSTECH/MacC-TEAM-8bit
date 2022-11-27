//
//  String+.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/22.
//

import UIKit
import Photos

extension String {
    
    func underLineAttribute() -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hex: "969696"),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: self,
            attributes: attributes
        )
        
        return attributeString
    }
    
    
    //MARK: String -> Date 타입 변환 메서드
    func stringToDate() -> Date? { // "yyyy-MM-dd 00:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    // MARK: String -> UIImage 변환 메서드
    // PHAsset Local Identifier로부터 영상 썸네일을 생성해 반환
    func generateCardViewThumbnail() -> UIImage? {
        
        guard let asset: PHAsset = PHAsset.fetchAssets(withLocalIdentifiers: [self], options: .none).firstObject else { return nil }
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = true
        
        var thumbnail = UIImage()
        
        manager.requestImage(for: asset,
                             targetSize:  CGSize(width: 500, height: 500),
                             contentMode: .aspectFit,
                             options: option,
                             resultHandler: {(result, info) -> Void in
            if result == nil { return }
            thumbnail = result!
        })
        
        return thumbnail
    }
}
