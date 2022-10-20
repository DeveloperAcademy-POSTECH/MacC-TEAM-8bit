//
//  VideoCollectionViewCustomCell.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/20.
//

import UIKit
import SnapKit

class VideoCollectionViewCell : UICollectionViewCell{
    static let identifier = "customVideoCollectionCell"
    
    private lazy var cellImage : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "")
        return
    }()
    
    private lazy var cellLabel : UILabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "V2"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.backgroundColor = .red
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    
    
}
