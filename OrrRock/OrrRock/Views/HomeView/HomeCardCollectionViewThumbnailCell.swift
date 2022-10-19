//
//  CardCollectionViewThumbnailCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// HomeCollectionViewCardCell에서 setData() 함수를 통해 이미지를 받아와 thumbnailView에 이미지를 넣어주는 기능 구현 필요.
// 혹은, URL 링크를 받아와, ThumbnailCell 내에서 해당 이미지를 호출하는 기능 구현 필요.
// 색상 확정나면 지정해주기


import SnapKit
import UIKit

final class HomeCardCollectionViewThumbnailCell: UICollectionViewCell {
    private let thumbnailView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    func setLayout() {
        contentView.addSubview(thumbnailView)
        thumbnailView.backgroundColor = .systemGray
        
        thumbnailView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func setData(image: UIImage?) {
        thumbnailView.image = image
    }
}
