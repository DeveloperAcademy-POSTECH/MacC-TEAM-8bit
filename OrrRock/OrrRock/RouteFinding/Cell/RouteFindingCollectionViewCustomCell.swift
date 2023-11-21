//
//  RouteFindingCollectionViewCustomCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/24.
//

import UIKit
import SnapKit
import Then

final class RouteFindingCollectionViewCustomCell: UICollectionViewCell {
    static let identifier = "RouteFindingCollectionViewCustomCell"
    
    override var isSelected: Bool {
        didSet {
            checkImage.isHidden = !isSelected
        }
    }
    
    var isSelectable = false {
        didSet {
            selectableImage.isHidden = !isSelectable
        }
    }
    
    private lazy var selectableImage: UIImageView = .init().then {
        $0.image = UIImage(named: "selectable_icon")
        $0.isHidden = true
    }
    
    private lazy var checkImage: UIImageView = .init().then {
        $0.image = UIImage(named: "Check")
        $0.isHidden = true
    }
    
    lazy var cellImage: UIImageView = .init().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "SwipeOnboardingImage1")
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhiteCustom
        return view
    }()
    
    lazy var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아띠 클라이밍"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    lazy var cellDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022년 10월 1일"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    lazy var cellLevelLabel: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.text = "V3"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .orrGray700
        label.textColor = .orrWhite
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11.5
        label.padding = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        return label
    }()
    
    lazy var cellChallengeLabel: UILabel = {
        let label = UILabel()
        label.text = "도전 중"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = .orrGray300
        self.addSubview(cellImage)
        cellImage.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalTo(0)
        }
        
        self.addSubview(selectableImage)
        selectableImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(OrrPd.pd8.rawValue)
            $0.trailing.equalToSuperview().inset(OrrPd.pd8.rawValue)
        }
        
        self.addSubview(checkImage)
        checkImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(OrrPd.pd8.rawValue)
            $0.trailing.equalToSuperview().inset(OrrPd.pd8.rawValue)
        }
        
        self.addSubview(infoView)
        infoView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalToSuperview()
            $0.height.equalTo(94)
        }
        
        infoView.addSubview(cellTitleLabel)
        cellTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(OrrPd.pd8.rawValue)
        }
        
        infoView.addSubview(cellDateLabel)
        cellDateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(OrrPd.pd8.rawValue)
            $0.top.equalTo(cellTitleLabel.snp.bottom).offset(OrrPd.pd4.rawValue)
        }
        
        infoView.addSubview(cellLevelLabel)
        cellLevelLabel.snp.makeConstraints {
            $0.top.equalTo(cellDateLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(12)
        }
        
        infoView.addSubview(cellChallengeLabel)
        cellChallengeLabel.snp.makeConstraints {
            $0.leading.equalTo(cellLevelLabel.snp.trailing).offset(OrrPd.pd4.rawValue)
            $0.centerY.equalTo(cellLevelLabel)
        }
    }
}

