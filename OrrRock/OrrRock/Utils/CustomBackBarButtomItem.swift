//
//  CustomBackButtonItem.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/17.
//

import UIKit

class CustomBackBarButtomItem: UIBarButtonItem {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(target: AnyObject?, action: Selector) {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.setTitle("longlong", for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)

        self.init(customView: button)
    }
}
