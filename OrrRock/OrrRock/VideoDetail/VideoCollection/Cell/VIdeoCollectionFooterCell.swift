//
//  VIdeoCollectionFootCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/21.
//

import UIKit


final class VideoCollectionFooterCell: UICollectionReusableView {
    static let id = "VideoCollectionFooterCell"
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .orrGray700
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight:.light)
        return label
    }()
    
    private let subTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .orrBlack
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight:.bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orrWhite
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(title: nil,count : 0,successCount: 0,failCount: 0)
    }
    
    func prepare(title: String?,count : Int,successCount : Int , failCount : Int) {
        self.titleLabel.text = "\(successCount)번의 성공, \(failCount)번의 실패"
        self.subTitleLabel.text = "\(count)개의 기록"
    }
    
    func setUpLayout(){
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25)
        }
        self.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints { $0
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
}
