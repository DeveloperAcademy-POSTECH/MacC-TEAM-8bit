//
//  AutocompleteTableViewCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/15.
//

import UIKit

import SnapKit
import Then

protocol AutocompleteTableViewCellDelegate {
    func tapDeleteButton(deleteTarget: VisitedClimbingGym)
}

final class AutocompleteTableViewCell: UITableViewCell {
    static let identifier = "autocompleteTableViewCell"
    
    private var gymName: String = ""
    private var gymData: VisitedClimbingGym? = nil
    var delegate: AutocompleteTableViewCellDelegate?
    
    // MARK: UI Components
    private lazy var locationIconView: UIImageView = .init().then {
        $0.image = UIImage(named: "location icon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var gymNameLabel: UILabel = .init().then {
        $0.text = "최근에 방문한 클라이밍장"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = UIColor.orrGray600
    }
    
    private lazy var deleteButton: UIButton = .init().then {
        $0.setImage(UIImage(systemName: "multiply"), for: .normal)
        $0.tintColor = UIColor.orrGray600
        $0.addTarget(self, action: #selector(tapDeleteButton(_:)), for: .touchUpInside)
    }
    
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpData(data: VisitedClimbingGym) {
        self.gymData = data
        self.gymNameLabel.text = data.name
    }
    
    @objc func tapDeleteButton(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.tapDeleteButton(deleteTarget: gymData!)
    }
}

extension AutocompleteTableViewCell {
    private func setUpLayout() {
        contentView.addSubview(locationIconView)
        locationIconView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(CGFloat(OrrPd.pd16.rawValue))
            $0.height.equalToSuperview()
            $0.width.equalTo(28)
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-CGFloat(OrrPd.pd16.rawValue))
            $0.height.equalToSuperview()
            $0.width.equalTo(20)
        }
        
        contentView.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIconView.snp.trailing).offset(CGFloat(OrrPd.pd8.rawValue))
            $0.trailing.equalTo(deleteButton.snp.leading)
            $0.height.equalToSuperview()
        }
    }
}
