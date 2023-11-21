//
//  HomeTableViewFooter.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/16.
//

import UIKit

import SnapKit
import Then

class HomeTableViewFooter: UITableViewHeaderFooterView {
    static let identifier: String = "HomeTableViewFooter"
    
    private lazy var roundCornerView: UIView = .init().then {
        $0.backgroundColor = .orrWhiteCustom
        $0.layer.cornerRadius = 10
}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension HomeTableViewFooter{
    func setUpLayout() {
        contentView.addSubview(roundCornerView)
        roundCornerView.snp.makeConstraints {
            $0.width.equalTo(contentView.snp.width)
            $0.height.equalTo(10)
            $0.top.equalTo(contentView.snp.top).offset(-5)
        }
    }
}
