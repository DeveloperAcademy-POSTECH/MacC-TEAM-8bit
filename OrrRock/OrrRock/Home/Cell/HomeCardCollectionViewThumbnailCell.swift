//
//  CardCollectionViewThumbnailCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/19.
//

import UIKit

import SnapKit
import Then

final class HomeCardCollectionViewThumbnailCell: UICollectionViewCell {
    private lazy var thumbnailView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
    }
    
    func setUpLayout() {
        contentView.addSubview(thumbnailView)
        thumbnailView.backgroundColor = .orrGray300
        
        thumbnailView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func setUpData(image: UIImage?) {
        thumbnailView.image = image
    }
}
