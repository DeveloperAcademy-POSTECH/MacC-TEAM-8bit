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
    private lazy var thumbnailView: UIImageView = {
        let view = UIImageView()
        
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
        thumbnailView.backgroundColor = .orrGray3
        
        thumbnailView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func setUpData(image: UIImage?) {
        thumbnailView.image = image
    }
}
