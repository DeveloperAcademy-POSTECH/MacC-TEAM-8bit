//
//  CardCollectionViewThumbnailCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

import UIKit

import SnapKit

final class HomeCardCollectionViewThumbnailCell: UICollectionViewCell {
    private lazy var thumbnailView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
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
        thumbnailView.backgroundColor = .orrGray400
        
        thumbnailView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func setUpData(image: UIImage?) {
        thumbnailView.image = image
    }
}
