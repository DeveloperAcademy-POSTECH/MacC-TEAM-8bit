//
//  HomeCollectionViewCardCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// cell을 생성하며 setData 함수를 통해 데이터를 받아와 HomeViewController에서 visitedDate, visitedGymName, successCount, failCount, videoCount, videoThumbnails을 저장 및 데이터 지정하도록 함수 작성
// 혹은 CardCell이 생성될 때 해당 데이터를 Load 해오도록 함수 작성

import Foundation
import SnapKit
import UIKit

class HomeCollectionViewCardCell: UICollectionViewCell {
    
    // MARK: Data
    var visitedDate: Date = Date()
    var visitedGymName: String = "클라이밍장 정보"
    var successCount: Int = 0
    var failCount: Int = 0
    var videoCount: Int = 0
    var videoThumbnails: [UIImage] = []
    
    // MARK: UI Components
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "YYYY년 MM월 DD일"
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    let gymLabel: UILabel = {
        let view = UILabel()
        view.text = "클라이밍장 정보"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    let thumbnailCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        view.backgroundColor = UIColor.white
        view.register(HomeCardCollectionViewThumbnailCell.classForCoder(), forCellWithReuseIdentifier: "homeCardCollectionViewThumbnailCell")
        
        return view
    }()
    
    let countPFLabel: UILabel = {
        let view = UILabel()
        view.text = "N번의 성공, N번의 실패"
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    let countTotalVideoLabel: UILabel = {
        let view = UILabel()
        view.text = "N개의 비디오"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    
    let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    // MARK: View Lifecycle Function
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCollectionView()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setCollectionView()
        setLayout()
    }
    
    // MARK: Layout Function
    func setLayout() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        cardView.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(cardView.snp.leading)
            make.trailing.equalTo(cardView.snp.trailing)
            make.centerY.equalTo(cardView.snp.centerY)
            make.height.equalTo(((UIScreen.main.bounds.width - 32) / 5 * 2))
        }
        
        cardView.addSubview(gymLabel)
        gymLabel.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnailCollectionView.snp.top).offset(-8)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(gymLabel.snp.top).offset(-4)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(countPFLabel)
        countPFLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(countTotalVideoLabel)
        countTotalVideoLabel.snp.makeConstraints { make in
            make.top.equalTo(countPFLabel.snp.bottom).offset(4)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailCollectionView.snp.bottom).offset(16)
            make.trailing.equalTo(cardView.snp.trailing).offset(-20)
        }
    }
    
    func setCollectionView() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
    
    // MARK: Value Assign Function
    
    let dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "yyyy년 M월 d일"
        return df
    }()
    
    func setData() {
        dateLabel.text = dateFormatter.string(from: visitedDate)
        gymLabel.text = visitedGymName
        countPFLabel.text = "\(successCount)번의 성공, \(failCount)번의 실패"
        countTotalVideoLabel.text = "\(videoCount)개의 비디오"
    }
}
