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
    var videoThumbnails: [UIImage] = []
    
    // MARK: UI Components
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.text = "YYYY년 MM월 DD일"
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "location.square.fill")
        view.tintColor = .orrGray3
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var gymLabel: UILabel = {
        let view = UILabel()
        view.text = "클라이밍장 정보"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .orrGray3
        return view
    }()
    
    private lazy var gymStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [locationIconImageView, gymLabel])
        view.spacing = 0
        view.axis = .horizontal
        return view
    }()
    
    lazy var thumbnailCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        view.backgroundColor = UIColor.orrWhite
        view.register(HomeCardCollectionViewThumbnailCell.classForCoder(), forCellWithReuseIdentifier: "homeCardCollectionViewThumbnailCell")
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private lazy var countPFLabel: UILabel = {
        let view = UILabel()
        view.text = "N번의 성공, N번의 실패"
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    private lazy var countTotalVideoLabel: UILabel = {
        let view = UILabel()
        view.text = "N개의 비디오"
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .orrGray3
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
        super.init(coder: coder)
        setUpLayout()
        setCollectionViewDelegate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
        setCollectionViewDelegate()
    }
    
    // MARK: Layout Function
    func setUpLayout() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        cardView.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPadding.padding1.rawValue))
            $0.trailing.equalTo(cardView.snp.trailing).offset(-CGFloat(OrrPadding.padding1.rawValue))
            $0.centerY.equalTo(cardView.snp.centerY).offset(CGFloat(OrrPadding.padding1.rawValue))
            $0.height.equalTo(((UIScreen.main.bounds.width - CGFloat(OrrPadding.padding3.rawValue) * 2) / 5 * 2))
        }
        
        cardView.addSubview(gymStackView)
        gymStackView.snp.makeConstraints {
            $0.bottom.equalTo(thumbnailCollectionView.snp.top).offset(-CGFloat(OrrPadding.padding2.rawValue))
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
        }
        
        cardView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(gymStackView.snp.top).inset(-CGFloat(OrrPadding.padding1.rawValue))
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
        }
        
//        cardView.addSubview(countPFLabel)
//        countPFLabel.snp.makeConstraints {
//            $0.top.equalTo(thumbnailCollectionView.snp.bottom).offset(CGFloat(OrrPadding.padding2.rawValue))
//            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
//        }
        
        cardView.addSubview(countTotalVideoLabel)
        countTotalVideoLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailCollectionView.snp.bottom).offset(CGFloat(OrrPadding.padding3.rawValue))
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
        }
        
        cardView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailCollectionView.snp.bottom).offset(CGFloat(OrrPadding.padding3.rawValue))
            $0.trailing.equalTo(cardView.snp.trailing).offset(-CGFloat(OrrPadding.padding3.rawValue))
        }
    }
    
    func setCollectionViewLayout() {
        thumbnailCollectionView.snp.removeConstraints()
        thumbnailCollectionView.snp.makeConstraints {
            $0.leading.equalTo(cardView.snp.leading).offset(CGFloat(OrrPadding.padding1.rawValue))
            $0.trailing.equalTo(cardView.snp.trailing).offset(-CGFloat(OrrPadding.padding1.rawValue))
            $0.centerY.equalTo(cardView.snp.centerY).offset(CGFloat(OrrPadding.padding1.rawValue))
            $0.height.equalTo((UIScreen.main.bounds.width - CGFloat(OrrPadding.padding3.rawValue) * 2) / 5 * (videoThumbnails.count > 5 ? 2 : 1))
        }
    }
    
    func setLocationIconView(_ sortOption: SortOption) {
        locationIconImageView.snp.removeConstraints()
        locationIconImageView.snp.makeConstraints {
            $0.width.equalTo(sortOption == .gymName ? 0 : 20)
            $0.height.equalTo(18)
        }
    }
    
    func setCollectionViewDelegate() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
    
    // MARK: Value Assign Function
    func setUpData(primaryTitle: String, secondaryTitle: String, PFCountDescription: String, videoCountDescription: String, thumbnails: [UIImage], sortOption: SortOption) {
        dateLabel.text = primaryTitle
        gymLabel.text = secondaryTitle
        countPFLabel.text = PFCountDescription
        countTotalVideoLabel.text = videoCountDescription
        videoThumbnails = thumbnails
        setLocationIconView(sortOption)
        
        self.thumbnailCollectionView.reloadData()
        setCollectionViewLayout()
    }
}
