//
//  ImageButton.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/25.
//

//출처 : https://minios.tistory.com/6
import UIKit

class ImageButton: UIButton {
    let pointSize: CGFloat = 12
    let imagePadding: CGFloat = 8
 
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        tintColor = .white
 
        let imageConfig = UIImage.SymbolConfiguration(pointSize: pointSize)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = imagePadding
            config.imagePlacement = .top
            
            config.preferredSymbolConfigurationForImage = imageConfig
            configuration = config
        } else {
            // imageSize == fontSize 일때 가능
            guard let image = self.imageView?.image else { return }
            guard let titleLabel = self.titleLabel else { return }
            guard let titleText = titleLabel.text else { return }
            let titleSize = titleText.size(withAttributes: [
                NSAttributedString.Key.font: titleLabel.font as Any
            ])
            titleEdgeInsets = UIEdgeInsets(top: imagePadding, left: -image.size.width, bottom: -image.size.height, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + imagePadding), left: 0, bottom: 0, right: -titleSize.width)
            
            setPreferredSymbolConfiguration(imageConfig, forImageIn: .normal)
        }
 
    }
 
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        guard let text = title else { return }
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: pointSize)]
        let attributedTitle = NSAttributedString(string: text, attributes: attribute)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
