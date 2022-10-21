//
//  VIdeoCollectionFootCell.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/21.
//

import UIKit


final class VideoCollectionFooterCell: UICollectionReusableView {
    static let id = "VideoCollectionFooterCell"
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight:.medium)
        return label
    }()
    
    private let subTitleLabel : UILabel = {
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
        self.prepare(title: nil,count : 0,successCount: 0,failCount: 0)
    }
    
    func prepare(title: String?,count : Int,successCount : Int , failCount : Int) {
        self.titleLabel.text = "\(successCount)번의 성공, \(failCount)번의 실패"
        self.subTitleLabel.text = "\(count)개의 비디오"
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
