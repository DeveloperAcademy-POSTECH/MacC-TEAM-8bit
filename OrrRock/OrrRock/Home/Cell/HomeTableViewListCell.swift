//
//  HomeCollectionViewListCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/20.
//

import UIKit
import Then

final class HomeTableViewListCell: UITableViewCell {
    static let identifier = "homeTableViewListCell"
    
    private lazy var cellView: UIView = .init()
    
    private lazy var thumbnailView: UIImageView = .init().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = .orrGray300
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var dividerView: UIView = .init().then {
        $0.backgroundColor = .orrGray300
    }
    
    private lazy var levelAndPFLabel: UILabel = .init().then {
        $0.text = "V6"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .orrBlack
    }
    
    private lazy var PFLabel: UILabel = .init().then {
        $0.text = "성공"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .orrBlack
    }
    
    private lazy var feedbackLabel: UILabel = .init().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .orrGray600
        $0.numberOfLines = 2
    }
    
    private lazy var feedbackPlaceholder: UILabel = .init().then {
        $0.text = "작성된 피드백이 없습니다."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .orrGray500
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
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
        contentView.backgroundColor = .orrWhiteCustom
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(CGFloat(OrrPd.pd16.rawValue))
        }
        
        cellView.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints {
            $0.leading.equalTo(cellView.snp.leading)
            $0.top.bottom.equalToSuperview().inset(CGFloat(OrrPd.pd16.rawValue))
            $0.width.equalTo(thumbnailView.snp.height)
        }
        
        cellView.addSubview(levelAndPFLabel)
        levelAndPFLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(OrrPd.pd16.rawValue))
            $0.top.equalTo(thumbnailView.snp.top)
        }
        
        cellView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(OrrPd.pd16.rawValue))
            $0.trailing.equalTo(cellView.snp.trailing)
            $0.top.equalTo(levelAndPFLabel.snp.bottom).offset(CGFloat(OrrPd.pd4.rawValue))
            $0.bottom.equalTo(thumbnailView.snp.bottom)
        }
        
        cellView.addSubview(feedbackPlaceholder)
        feedbackPlaceholder.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(CGFloat(OrrPd.pd16.rawValue))
            $0.trailing.equalTo(cellView.snp.trailing)
            $0.top.equalTo(levelAndPFLabel.snp.bottom).offset(CGFloat(OrrPd.pd4.rawValue))
            $0.bottom.equalTo(thumbnailView.snp.bottom)
        }
        
        cellView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(10)
            $0.trailing.equalTo(cellView.snp.trailing)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setUpData(level: String, PF: String, thumbnail: UIImage?, feedback: String) {
        levelAndPFLabel.text = "\(level == "V-1" ? "V?" : level) \(PF)"
        PFLabel.text = PF
        thumbnailView.image = thumbnail
        
        if !feedback.isEmpty {
            feedbackPlaceholder.isHidden = true
            feedbackLabel.text = feedback
        } else {
            feedbackPlaceholder.isHidden = false
            feedbackLabel.text = ""
        }
    }
}
