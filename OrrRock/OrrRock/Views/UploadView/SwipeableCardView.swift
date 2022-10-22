//
//  SwipeableCardView.swift
//  OrrRock
//
//  Created by 이성노, Yeni Hwang on 2022/10/21.
//

import UIKit
import SnapKit

final class SwipeableCardView: UIView {

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

        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SwipeableCardView {

    func setUpLayout() {
        addSubview(photoImageView)

        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
