//
//  PageTableViewCell.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import UIKit

class PageTableViewCell: UITableViewCell {

    static let identifier = "PageTableViewCell"
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .yellow
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [numberLabel].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 300),
            numberLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        self.layer.borderColor = UIColor.yellow.cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = .clear
        
        self.accessoryType = .detailButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PageTableViewCell {
    func labelConfigure(writtenDateText: String) {
        numberLabel.text = writtenDateText
    }
}
