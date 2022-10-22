//
//  HomeCollectionViewListCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/20.
//

import UIKit

final class HomeCollectionViewListCell: UICollectionViewCell {
    static let identifier = "homeCollectionViewListCell"
    
    private lazy var cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var thumbnailView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .orrGray3
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray2
        return view
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "location.square.fill")
        view.tintColor = .orrGray3
        view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        return view
    }()
    
    private lazy var gymNameLabel: UILabel = {
        let view = UILabel()
        view.text = "아띠 클라이밍"
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.textColor = .orrGray3
        return view
    }()
    
    private lazy var visitedDateLabel: UILabel = {
       let view = UILabel()
        view.text = "2022년 12월 30일"
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [visitedDateLabel, gymNameLabel])
        view.axis = .horizontal
        return view
    }()
    
    private lazy var levelLabel: UILabel = {
        let view = UILabel()
        view.text = "V6"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .orrGray3
        return view
    }()
    
    private lazy var PFLabel: UILabel = {
        let view = UILabel()
        view.text = "성공"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .orrGray3
        return view
    }()
    
    
    // MARK: View Lifecycle Function
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
    }
    
    // MARK: Layout Function
    func setUpLayout() {
        contentView.backgroundColor = .orrWhite
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat(orrPadding.padding3.rawValue))
            $0.trailing.equalTo(contentView.snp.trailing).inset(CGFloat(orrPadding.padding3.rawValue))
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(50)
        }
        
        cellView.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints {
            $0.leading.equalTo(cellView.snp.leading)
            $0.height.equalTo(cellView.snp.height)
            $0.width.equalTo(cellView.snp.height)
        }
        
        cellView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(cellView.snp.top).offset(CGFloat(orrPadding.padding1.rawValue))
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(orrPadding.padding3.rawValue))
            $0.trailing.equalTo(cellView.snp.trailing)
        }
        
        cellView.addSubview(locationIconImageView)
        locationIconImageView.snp.makeConstraints {
            $0.trailing.equalTo(gymNameLabel.snp.leading).offset(-CGFloat(orrPadding.padding1.rawValue))
            $0.centerY.equalTo(gymNameLabel.snp.centerY)
        }
        
        cellView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(orrPadding.padding3.rawValue))
            $0.top.equalTo(stackView.snp.bottom).offset(CGFloat(orrPadding.padding1.rawValue))
        }
        
        cellView.addSubview(PFLabel)
        PFLabel.snp.makeConstraints {
            $0.leading.equalTo(levelLabel.snp.trailing).offset(CGFloat(orrPadding.padding2.rawValue))
            $0.top.equalTo(stackView.snp.bottom).offset(CGFloat(orrPadding.padding1.rawValue))
        }
        
        cellView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.bottom.equalTo(cellView.snp.bottom).offset(-1)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(orrPadding.padding3.rawValue))
            $0.trailing.equalTo(cellView.snp.trailing)
            $0.height.equalTo(1)
        }
    }
}
