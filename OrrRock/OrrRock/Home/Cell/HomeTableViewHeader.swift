//
//  HomeTableViewHeader.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/16.
//

import UIKit

import SnapKit

class HomeTableViewHeader: UITableViewHeaderFooterView {
    static let identifier: String = "HomeTableViewHeader"
    
    private lazy var backgroundSubview: UIView = {
       let view = UIView()
        view.backgroundColor = .orrWhite
        return view
    }()
    
    private lazy var primaryTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.textColor = .orrBlack
        return view
    }()
    
    private lazy var secondaryTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.textColor = .orrGray600
        return view
    }()
    
    private lazy var roundCornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        view.layer.cornerRadius = 8
        return view
    }()
    
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
            $0.bottom.equalTo(contentView.snp.bottom).offset(-CGFloat(OrrPadding.padding1.rawValue))
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
        }
        
        contentView.addSubview(primaryTitleLabel)
        primaryTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(secondaryTitleLabel.snp.top).offset(-CGFloat(OrrPadding.padding1.rawValue))
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
        }
    }
}
