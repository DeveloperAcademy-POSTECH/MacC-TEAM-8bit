//
//  RouteFindingCollectionViewHeaderCell.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/24.
//

import UIKit

protocol RouteFindingCollectionViewHeaderCellDelegate{
    func tapEditButton()
}

final class RouteFindingCollectionViewHeaderCell: UICollectionReusableView {
    static let id = "RouteFindingCollectionViewHeaderCell"
    
    var delegate : RouteFindingCollectionViewHeaderCellDelegate?
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight:.bold)
        return label
    }()
    
    let subTitleButton : UIButton = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.setTitleColor(UIColor.orrGray400, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.addTarget(self, action: #selector(buttonTouch), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orrGray100
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(title: "아띠 클라이밍",subtitle: "2022년 10월 26일",isEditing: false)
    }
    
    func prepare(title: String, subtitle: String, isEditing : Bool) {
        self.titleLabel.text = title
        self.subTitleButton.setTitle(isEditing ? "완료" : "편집", for:.normal)
        self.subTitleButton.setTitleColor(isEditing ? .orrUPBlue :.orrGray400, for: .normal)
    }
    
    func setUpLayout(){
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(OrrPd.pd16.rawValue)
            $0.leading.equalToSuperview()
        }
        
        self.addSubview(self.subTitleButton)
        self.subTitleButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    @objc func buttonTouch(){  
        delegate?.tapEditButton()
    }
}
