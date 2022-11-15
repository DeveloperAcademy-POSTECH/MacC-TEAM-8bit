//
//  AutocompleteTableViewCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/15.
//

import UIKit

import SnapKit

final class AutocompleteTableViewCell: UITableViewCell {
    static let identifier = "autocompleteTableViewCell"

    private var gymName: String = ""
    private var gymData: VisitedClimbingGym? = nil
    
    // MARK: UI Components
    private lazy var locationIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "location icon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var gymNameLabel: UILabel = {
       let view = UILabel()
        view.text = "최근에 방문한 클라이밍장"
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textColor = UIColor.orrGray4
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "multiply"), for: .normal)
        view.tintColor = UIColor.orrGray4
        return view
    }()

    
    
    // MARK: View Lifecycle Function
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLayout()
        contentView.backgroundColor = .systemRed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpData(data: VisitedClimbingGym) {
        self.gymData = data
        self.gymNameLabel.text = data.name
    }
}

extension AutocompleteTableViewCell {
    private func setUpLayout() {
        contentView.addSubview(locationIconView)
        locationIconView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
            $0.height.equalToSuperview()
            $0.width.equalTo(20)
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-CGFloat(OrrPadding.padding3.rawValue))
            $0.height.equalToSuperview()
            $0.width.equalTo(20)
        }
        
        contentView.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIconView.snp.trailing).offset(CGFloat(OrrPadding.padding2.rawValue))
            $0.trailing.equalTo(deleteButton.snp.leading)
            $0.height.equalToSuperview()
        }
    }
}
