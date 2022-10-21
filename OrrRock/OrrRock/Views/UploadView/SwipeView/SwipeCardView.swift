//
//  SwipeView.swift
//  OrrRock
//
//  Created by 이성노 on 2022/10/21.
//

import UIKit
import SnapKit

final class SwipeView: UIView {
    
    private lazy var swipeCard: UIView = {
        let swipeView = UIView()
        swipeView.backgroundColor = .red
        
        return swipeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
    }
}

private extension SwipeView {
    
    func setupLayout() {
        view.addSubview(swipeCard)
        swipeCard.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(60.0)
            $0.height.equalTo(450.0)
            $0.centerY.equalToSuperview()
        }
    }
}
