//
//  RouteTableViewCell.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    static let identifier = "RouteTableViewCell"
    
    lazy var writtenDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private lazy var gymNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var problemLevelLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var isChallengeCompleteLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [writtenDateLabel, gymNameLabel, problemLevelLabel, isChallengeCompleteLabel].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            gymNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            gymNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gymNameLabel.widthAnchor.constraint(equalToConstant: 300),
            gymNameLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RouteTableViewCell {
    func labelConfigure(routeInfo: RouteInformation) {
        print(routeInfo)
        if routeInfo.dataWrittenDate == nil {
            print("NO DATA>....")
        } else {
            gymNameLabel.text = "ROUTE \(routeInfo.dataWrittenDate)"
        }
    }
}
