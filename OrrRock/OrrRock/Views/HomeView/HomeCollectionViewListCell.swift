//
//  HomeCollectionViewListCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/20.
//

import UIKit

final class HomeCollectionViewListCell: UICollectionViewCell {
    private lazy var cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var thumbnailView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "location.square.fill")
        view.tintColor = .systemGray4
        view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        return view
    }()
    
    private lazy var gymNameLabel: UILabel = {
        let view = UILabel()
        view.text = "아띠 클라이밍"
        view.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        view.textColor = .systemGray3
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
        view.textColor = .systemGray3
        return view
    }()
    
    private lazy var PFLabel: UILabel = {
        let view = UILabel()
        view.text = "성공"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .systemGray3
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
        contentView.backgroundColor = .white
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).inset(20)
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
        
        cellView.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints {
            $0.leading.equalTo(cellView.snp.leading)
            $0.height.equalTo(cellView.snp.height)
            $0.width.equalTo(cellView.snp.height)
        }
        
        cellView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(cellView.snp.top).offset(6)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(15)
            $0.trailing.equalTo(cellView.snp.trailing)
        }
        
        cellView.addSubview(locationIconImageView)
        locationIconImageView.snp.makeConstraints {
            $0.trailing.equalTo(gymNameLabel.snp.leading).offset(-5)
            $0.centerY.equalTo(gymNameLabel.snp.centerY)
        }
        
        cellView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(15)
            $0.top.equalTo(stackView.snp.bottom).offset(4)
        }
        
        cellView.addSubview(PFLabel)
        PFLabel.snp.makeConstraints {
            $0.leading.equalTo(levelLabel.snp.trailing).offset(8)
            $0.top.equalTo(stackView.snp.bottom).offset(4)
        }
        
        cellView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.bottom.equalTo(cellView.snp.bottom).offset(-1)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(15)
            $0.trailing.equalTo(cellView.snp.trailing)
            $0.height.equalTo(1)
        }
    }
}
