//
//  HomeCollectionViewListCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/20.
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
        view.backgroundColor = .orrGray300
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray300
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
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .orrGray600
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var feedbackPlaceholder: UILabel = {
        let view = UILabel()
        view.text = "작성된 피드백이 없습니다."
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .orrGray500
        view.numberOfLines = 2
        view.textAlignment = .left
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
