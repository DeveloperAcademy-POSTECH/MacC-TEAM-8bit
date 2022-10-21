//
//  VideoCollectionViewCustomCell.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/20.
//

import UIKit
import SnapKit

class VideoCollectionViewCell : UICollectionViewCell {
    static let identifier = "customVideoCollectionCell"
    
    
    lazy var cellImage : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "s")
        return img
    }()
    
    lazy var cellLabel : UILabel = {
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
    
    lazy var heartImage : UIView  = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "heart.fill")
        img.tintColor = .white
        img.contentMode = .scaleToFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        self.backgroundColor = .gray
        self.addSubview(cellImage)
        cellImage.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(0)
            $0.bottom.equalTo(0)
        }
        self.addSubview(cellLabel)
        cellLabel.snp.makeConstraints {
            $0.bottom.equalTo(cellImage.snp.bottom).offset(-16)
            $0.leading.equalTo(cellImage.snp.leading).offset(16)
        }
        self.addSubview(heartImage)
        heartImage.snp.makeConstraints {
            $0.leading.equalTo(cellLabel.snp.trailing).offset(1)
            $0.centerY.equalTo(cellLabel.snp.centerY)
        }
        
    }
}
