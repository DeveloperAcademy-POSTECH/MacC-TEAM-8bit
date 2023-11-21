//
//  HomeCollectionViewCardCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/19.
//

import UIKit

import SnapKit
import Then

final class HomeTableViewCardCell: UITableViewCell {
    static let identifier = "homeTableViewCardCell"
    
    // MARK: Data
    private var visitedDate: String = "YYYY년 MM월 DD일"
    private var visitedGymName: String = "클라이밍장 정보"
    private var PFCountDescription: String = "N번의 성공, N번의 실패"
    private var videoCountDescription: String = "N개의 기록"
    var videoThumbnails: [UIImage?] = []
    
    // MARK: UI Components
    private lazy var cardView: UIView = .init().then {
        $0.backgroundColor = .orrWhiteCustom
        $0.layer.cornerRadius = 10
    }
    
    private lazy var cardAnchorView: UIView = .init().then {
        $0.backgroundColor = .systemRed
    }
    
    private lazy var dateLabel: UILabel = .init().then {
        $0.text = "YYYY년 MM월 DD일"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    private lazy var gymLabel: UILabel = .init().then {
        $0.text = "클라이밍장 정보"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .orrGray600
    }
    
    lazy var thumbnailCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        view.backgroundColor = .orrWhiteCustom
        view.register(HomeCardCollectionViewThumbnailCell.classForCoder(), forCellWithReuseIdentifier: "homeCardCollectionViewThumbnailCell")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var countTotalVideoLabel: UILabel = .init().then {
        $0.text = "N개의 기록"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .orrGray500
    }
    
    lazy var detailLabel: UILabel = .init().then {
        $0.text = "더 보기"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .orrUPBlue
    }
    
    // MARK: View Lifecycle Function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .orrGray050
        
        setUpLayout()
        setCollectionViewDelegate()
    }
    
    // MARK: Layout Function
    func setUpLayout() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(OrrPd.pd16.rawValue)
        }
        
        cardView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.top).offset(CGFloat(OrrPd.pd16.rawValue))
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPd.pd16.rawValue))
        }
        
        cardView.addSubview(gymLabel)
        gymLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(CGFloat(OrrPd.pd4.rawValue))
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPd.pd16.rawValue))
        }
            
        cardView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints {
            $0.bottom.equalTo(cardView.snp.bottom).offset(-CGFloat(OrrPd.pd16.rawValue))
            $0.trailing.equalTo(cardView.snp.trailing).offset(-CGFloat(OrrPd.pd16.rawValue))
        }
        
        cardView.addSubview(countTotalVideoLabel)
        countTotalVideoLabel.snp.makeConstraints {
            $0.centerY.equalTo(detailLabel.snp.centerY)
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPd.pd16.rawValue))
        }
        
        cardView.addSubview(cardAnchorView)
        cardAnchorView.snp.makeConstraints {
            $0.top.equalTo(gymLabel.snp.bottom)
            $0.bottom.equalTo(countTotalVideoLabel.snp.top)
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPd.pd16.rawValue))
        }
        
        cardView.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            let horizontalPadding: CGFloat = 2
            $0.leading.equalTo(cardView.snp.leading).offset(horizontalPadding)
            $0.trailing.equalTo(cardView.snp.trailing).offset(-horizontalPadding)
            $0.centerY.equalTo(cardAnchorView.snp.centerY)
            $0.height.equalTo(((UIScreen.main.bounds.width - horizontalPadding * 2) / 5 * 2))
        }
    }
    
    func setCollectionViewLayout() {
        thumbnailCollectionView.snp.removeConstraints()
        thumbnailCollectionView.snp.makeConstraints {
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPd.pd4.rawValue))
            $0.trailing.equalTo(cardView.snp.trailing).offset(-CGFloat(OrrPd.pd4.rawValue))
            $0.centerY.equalTo(cardAnchorView.snp.centerY)
            $0.height.equalTo((UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 2) / 5 * (videoThumbnails.count > 5 ? 2 : 1))
        }
    }
    
    func setCollectionViewDelegate() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
    
    // MARK: Value Assign Function
    func setUpData(primaryTitle: String, secondaryTitle: String, PFCountDescription: String, videoCountDescription: String, thumbnails: [UIImage?], sortOption: SortOption) {
        dateLabel.text = primaryTitle
        gymLabel.text = secondaryTitle
        countTotalVideoLabel.text = videoCountDescription
        videoThumbnails = thumbnails
        
        self.thumbnailCollectionView.reloadData()
        setCollectionViewLayout()
    }
}
