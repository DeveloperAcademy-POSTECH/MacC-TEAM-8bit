//
//  HomeCollectionViewFooterCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/20.
//

import UIKit

import SnapKit
import Then

final class HomeCollectionViewFooterCell: UICollectionReusableView {
    static let identifier = "HomeCollectionViewFooterCell"
    
    var isCardView: Bool = true {
        didSet {
            setUpLayout()
        }
    }
    
    private lazy var anchorView: UIView = .init()
    
    private lazy var footerRoundedSquare: UIView = .init().then {
        $0.backgroundColor = .orrWhite
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        anchorView.frame = bounds
    }
    
    private func setUpLayout() {
        footerRoundedSquare.snp.removeConstraints()
        
        if isCardView {
            footerRoundedSquare.snp.makeConstraints {
                $0.width.equalTo(0)
            }
        } else {
            addSubview(anchorView)
            addSubview(footerRoundedSquare)
            
            footerRoundedSquare.snp.makeConstraints {
                $0.top.equalTo(anchorView.snp.top).offset(-CGFloat(OrrPd.pd8.rawValue))
                
                $0.height.equalTo(CGFloat(OrrPd.pd16.rawValue))
                $0.width.equalTo(UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue)*2)
            }
        }
    }
}
