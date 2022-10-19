//
//  HomeCollectionViewHeaderCell.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// 퀵 액션에서 형태에 따라 headerTitle의 글자 변경 필요.

import Foundation
import SnapKit
import UIKit

class HomeCollectionViewHeaderCell: UICollectionReusableView {
    static let identifier = "HomeCollectionViewHeaderCell"
    
    let headerTitle: UILabel = {
        let view = UILabel()
        view.text = "모든 비디오"
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerTitle.frame = bounds
    }
    
    func setLayout() {
        addSubview(headerTitle)
        
    }
}
