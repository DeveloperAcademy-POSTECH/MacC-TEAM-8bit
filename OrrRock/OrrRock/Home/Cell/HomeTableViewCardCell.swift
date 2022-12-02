//
//  HomeCollectionViewCardCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

import UIKit

import SnapKit

final class HomeTableViewCardCell: UITableViewCell {
    static let identifier = "homeTableViewCardCell"
    
    // MARK: Data
    private var visitedDate: String = "YYYY년 MM월 DD일"
    private var visitedGymName: String = "클라이밍장 정보"
    private var PFCountDescription: String = "N번의 성공, N번의 실패"
    private var videoCountDescription: String = "N개의 비디오"
    var videoThumbnails: [UIImage?] = []
    
    // MARK: UI Components
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhiteCustom
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var cardAnchorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.text = "YYYY년 MM월 DD일"
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    private lazy var gymLabel: UILabel = {
        let view = UILabel()
        view.text = "클라이밍장 정보"
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .orrGray600
        return view
    }()
    
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
    
    private lazy var countTotalVideoLabel: UILabel = {
        let view = UILabel()
        view.text = "N개의 비디오"
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .orrGray500
        return view
    }()
    
    lazy var detailLabel: UILabel = {
        let view = UILabel()
        view.text = "더 보기"
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = .orrUPBlue
        return view
    }()
    
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
