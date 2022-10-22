//
//  VideoCollectionViewHeaderCell.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/21.
//


import UIKit

final class VideoCollectionViewHeaderCell: UICollectionReusableView {
    static let id = "VideoCollectionViewHeaderCell"
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23, weight:.bold)
        return label
    }()
    
    let subTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight:.light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(title: nil)
    }
    
    func prepare(title: String?) {
        self.titleLabel.text = "날짜"
        self.subTitleLabel.text = "클라이밍장 이름"
    }
    
    func setUpLayout(){
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(34)
        }
        
        self.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(23)
        }
    }
}
