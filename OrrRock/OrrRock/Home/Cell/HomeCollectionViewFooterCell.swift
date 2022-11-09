//
//  HomeCollectionViewFooterCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/20.
//

import UIKit

import SnapKit

final class HomeCollectionViewFooterCell: UICollectionReusableView {
    static let identifier = "HomeCollectionViewFooterCell"
    
    var isCardView: Bool = true {
        didSet {
            setUpLayout()
        }
    }
    
    private lazy var anchorView: UIView = {
        return UIView()
    }()
    
    private lazy var footerRoundedSquare: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        view.layer.cornerRadius = 10
        return view
    }()
    
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
                $0.top.equalTo(anchorView.snp.top).offset(-CGFloat(OrrPadding.padding2.rawValue))
                
                $0.height.equalTo(CGFloat(OrrPadding.padding3.rawValue))
                $0.width.equalTo(UIScreen.main.bounds.width - CGFloat(OrrPadding.padding3.rawValue)*2)
            }
        }
    }
}
