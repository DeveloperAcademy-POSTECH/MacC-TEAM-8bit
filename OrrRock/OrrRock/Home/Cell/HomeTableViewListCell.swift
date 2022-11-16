//
//  HomeCollectionViewListCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/20.
//

import UIKit

final class HomeTableViewListCell: UITableViewCell {
    static let identifier = "homeTableViewListCell"
    
    private lazy var cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var thumbnailView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .orrGray3
        view.contentMode = .scaleAspectFill

        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray2
        return view
    }()
    
    private lazy var levelAndPFLabel: UILabel = {
        let view = UILabel()
        view.text = "V6"
        view.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .orrBlack
        return view
    }()
    
    private lazy var PFLabel: UILabel = {
        let view = UILabel()
        view.text = "성공"
        view.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .orrBlack
        return view
    }()
    
    private lazy var feedbackLabel: UILabel = {
        let view = UILabel()
        view.text = "잠든 너의 맨발을 가만히 보다 왠지 모르게 벅차올라 맺히는 마음 방 안 가득 달큰한 호흡"
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .orrGray4
        view.numberOfLines = 2
        return view
    }()
    
    // MARK: View Lifecycle Function
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    // MARK: Layout Function
    func setUpLayout() {
        contentView.backgroundColor = .orrWhite
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints {
            $0.edges.equalTo(contentView.snp.edges).inset(CGFloat(OrrPadding.padding3.rawValue))
        }
        
        cellView.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints {
            $0.leading.equalTo(cellView.snp.leading)
            $0.centerY.equalTo(cellView.snp.centerY)
            $0.height.equalTo(cellView.snp.height)
            $0.width.equalTo(cellView.snp.height)
        }
        
        cellView.addSubview(levelAndPFLabel)
        levelAndPFLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(OrrPadding.padding3.rawValue))
            $0.top.equalTo(thumbnailView.snp.top)
        }
        
        cellView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(OrrPadding.padding3.rawValue))
            $0.trailing.equalTo(cellView.snp.trailing)
            $0.top.equalTo(levelAndPFLabel.snp.bottom).offset(CGFloat(OrrPadding.padding1.rawValue))
            $0.bottom.equalTo(cellView.snp.bottom)
        }
//        cellView.addSubview(dividerView)
//        dividerView.snp.makeConstraints {
//            $0.bottom.equalTo(cellView.snp.bottom).offset(-1)
//            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(OrrPadding.padding3.rawValue))
//            $0.trailing.equalTo(cellView.snp.trailing)
//            $0.height.equalTo(1)
//        }
    }
    
    func setUpData(visitedDate: String, visitedGymName: String, level: String, PF: String, thumbnail: UIImage) {
        levelAndPFLabel.text = "\(level == "V-1" ? "V?" : level) \(PF)"
        PFLabel.text = PF
        thumbnailView.image = thumbnail
    }
}
