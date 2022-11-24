//
//  RouteFindingCollectionViewHeaderCell.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/24.
//

import UIKit

final class RouteFindingCollectionViewHeaderCell: UICollectionReusableView {
    static let id = "RouteFindingCollectionViewHeaderCell"
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight:.bold)
        return label
    }()
    
    let subTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight:.bold)
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
        self.prepare(title: "아띠 클라이밍",subtitle: "2022년 10월 26일")
    }
    
    func prepare(title: String, subtitle: String) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subtitle
    }
    
    func setUpLayout(){
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(OrrPd.pd16.rawValue)
        }
        
        self.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(OrrPd.pd16.rawValue)
        }
    }
}
