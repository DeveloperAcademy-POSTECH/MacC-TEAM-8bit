//
//  HomeCollectionViewCardCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// cell을 생성하며 setData 함수를 통해 데이터를 받아와 HomeViewController에서 visitedDate, visitedGymName, successCount, failCount, videoCount, videoThumbnails을 저장 및 데이터 지정하도록 함수 작성
// 혹은 CardCell이 생성될 때 해당 데이터를 Load 해오도록 함수 작성
// 색상 확정나면 지정해주기


import SnapKit
import UIKit

final class HomeCollectionViewCardCell: UICollectionViewCell {
    
    // MARK: Data
    private var visitedDate: String = "YYYY년 MM월 DD일"
    private var visitedGymName: String = "클라이밍장 정보"
    private var PFCountDescription: String = "N번의 성공, N번의 실패"
    private var videoCountDescription: String = "N개의 비디오"
     var videoThumbnails: [UIImage] = []
    
    // MARK: UI Components
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "YYYY년 MM월 DD일"
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    private let gymLabel: UILabel = {
        let view = UILabel()
        view.text = "클라이밍장 정보"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    private let thumbnailCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        view.backgroundColor = UIColor.white
        view.register(HomeCardCollectionViewThumbnailCell.classForCoder(), forCellWithReuseIdentifier: "homeCardCollectionViewThumbnailCell")
        
        return view
    }()
    
    private let countPFLabel: UILabel = {
        let view = UILabel()
        view.text = "N번의 성공, N번의 실패"
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    private let countTotalVideoLabel: UILabel = {
        let view = UILabel()
        view.text = "N개의 비디오"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: View Lifecycle Function
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
        setCollectionViewDelegate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
        setCollectionViewDelegate()
    }
    
    // MARK: Layout Function
    func setLayout() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        cardView.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            $0.leading.equalTo(cardView.snp.leading)
            $0.trailing.equalTo(cardView.snp.trailing)
            $0.centerY.equalTo(cardView.snp.centerY)
            $0.height.equalTo(((UIScreen.main.bounds.width - 32) / 5 * 2))

        }
        
        cardView.addSubview(gymLabel)
        gymLabel.snp.makeConstraints {
            $0.bottom.equalTo(thumbnailCollectionView.snp.top).offset(-8)
            $0.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(gymLabel.snp.top).inset(-4)
            $0.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(countPFLabel)
        countPFLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailCollectionView.snp.bottom).offset(8)
            $0.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(countTotalVideoLabel)
        countTotalVideoLabel.snp.makeConstraints {
            $0.top.equalTo(countPFLabel.snp.bottom).offset(4)
            $0.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(detailButton)
        detailButton.snp.makeConstraints {
            $0.top.equalTo(thumbnailCollectionView.snp.bottom).offset(16)
            $0.trailing.equalTo(cardView.snp.trailing).offset(-20)
        }
    }
    
    func setCollectionViewDelegate() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
    
    // MARK: Value Assign Function
    func loadCardViewData(visitedDate: String, visitedGymName: String, PFCountDescription: String, videoCountDescription: String, thumbnails: [UIImage]) {
        dateLabel.text = visitedDate
        gymLabel.text = visitedGymName
        countPFLabel.text = PFCountDescription
        countTotalVideoLabel.text = videoCountDescription
        self.videoThumbnails = thumbnails
    }
}
