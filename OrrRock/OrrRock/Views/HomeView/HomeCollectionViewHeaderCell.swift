//
//  HomeCollectionViewHeaderCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// 퀵 액션에서 형태에 따라 headerTitle의 글자 변경 필요.

import SnapKit
import UIKit

final class HomeCollectionViewHeaderCell: UICollectionReusableView {
    static let identifier = "HomeCollectionViewHeaderCell"
    
    // HomeCollectionView에서 isCardView의 값을 바꿀 때 CollectionView의 reloadData 함수 호출
    // reloadData에 의해 HeaderCell이 다시 그려지며 isCardView 값을 지정하고, 이에 따라 didSet 호출되며 레이아웃 설정함
    var isCardView: Bool = false {
        didSet {
            setUpLayout()
        }
    }
    
    private lazy var headerTitle: UILabel = {
        let view = UILabel()
        view.text = "모든 비디오"
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return view
    }()
    
    private lazy var headerRoundedSquare: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var PFCountLabel: UILabel = {
        let view = UILabel()
        view.text = "NN번의 성공, NN번의 실패"
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private lazy var videoCountLabel: UILabel = {
        let view = UILabel()
        view.text = "NNN개의 비디오"
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.textColor = .systemGray2
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
    }
    
    private func setUpLayout() {
        addSubview(headerRoundedSquare)
        addSubview(videoCountLabel)
        addSubview(PFCountLabel)
        addSubview(headerTitle)
        
        setConstraints()
    }
    
    private func setConstraints() {
        headerRoundedSquare.snp.removeConstraints()
        videoCountLabel.snp.removeConstraints()
        PFCountLabel.snp.removeConstraints()
        
        headerTitle.snp.makeConstraints {
            $0.bottom.equalTo(snp_topMargin).offset(95)
        }
        
        if isCardView {
            headerRoundedSquare.snp.makeConstraints { $0.width.equalTo(0) }
            videoCountLabel.snp.makeConstraints{ $0.width.equalTo(0) }
            PFCountLabel.snp.makeConstraints{ $0.width.equalTo(0) }
            
        } else {
            headerRoundedSquare.snp.makeConstraints {
                $0.bottom.equalTo(snp_bottomMargin).offset(CGFloat(orrPadding.padding3.rawValue))
                $0.height.equalTo(CGFloat(orrPadding.padding3.rawValue))
                $0.width.equalTo(UIScreen.main.bounds.width - CGFloat(orrPadding.padding3.rawValue) * 2)
            }
            
            videoCountLabel.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width - CGFloat(orrPadding.padding3.rawValue) * 2)
                $0.bottom.equalTo(headerRoundedSquare.snp.top).offset(-CGFloat(orrPadding.padding3.rawValue))
            }
            
            PFCountLabel.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width - CGFloat(orrPadding.padding3.rawValue) * 2)
                $0.bottom.equalTo(videoCountLabel.snp.top).offset(-CGFloat(orrPadding.padding1.rawValue))
            }
        }
    }
}
