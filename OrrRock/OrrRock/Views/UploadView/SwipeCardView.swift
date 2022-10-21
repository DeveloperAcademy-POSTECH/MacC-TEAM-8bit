//
//  SwipeCardView.swift
//  OrrRock
//
//  Created by 이성노, Yeni Hwang on 2022/10/21.
//

import UIKit
import SnapKit

class SwipeCardView: UIView {

    // 목업용 이미지입니다
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gorilla")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwipeCardView {

    func setupLayout() {
        addSubview(photoImageView)

        photoImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
