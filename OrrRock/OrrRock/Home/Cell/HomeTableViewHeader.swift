//
//  HomeTableViewHeader.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/16.
//

import UIKit

import SnapKit
import Then

class HomeTableViewHeader: UITableViewHeaderFooterView {
    static let identifier: String = "HomeTableViewHeader"
    
    private lazy var backgroundSubview: UIView = .init().then {
        $0.backgroundColor = .orrWhiteCustom
    }
    
    private lazy var primaryTitleLabel: UILabel = .init().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .orrBlack
    }
    
    private lazy var secondaryTitleLabel: UILabel = .init().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .orrGray600
    }
    
    private lazy var roundCornerView: UIView = .init().then {
        $0.backgroundColor = .orrWhiteCustom
        $0.layer.cornerRadius = 8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpData(primaryTitle: String, secondaryTitle: String) {
        primaryTitleLabel.text = primaryTitle
        secondaryTitleLabel.text = secondaryTitle
        
        setUpLayout()
        contentView.backgroundColor = .clear
    }
}

extension HomeTableViewHeader {
    func setUpLayout() {
        contentView.addSubview(backgroundSubview)
        backgroundSubview.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(5)
        }
        
        
        contentView.addSubview(roundCornerView)
        roundCornerView.snp.makeConstraints {
            $0.width.equalTo(contentView.snp.width)
            $0.height.equalTo(10)
            $0.bottom.equalTo(backgroundSubview.snp.top).offset(5)
        }
        
        contentView.addSubview(secondaryTitleLabel)
        secondaryTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom).offset(-CGFloat(OrrPd.pd4.rawValue))
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat(OrrPd.pd16.rawValue))
        }
        
        contentView.addSubview(primaryTitleLabel)
        primaryTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(secondaryTitleLabel.snp.top).offset(-CGFloat(OrrPd.pd4.rawValue))
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat(OrrPd.pd16.rawValue))
        }
    }
}
