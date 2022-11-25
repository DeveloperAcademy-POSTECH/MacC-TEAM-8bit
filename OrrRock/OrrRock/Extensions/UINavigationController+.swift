//
//  UINavigationController+.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/25.
//

import UIKit

extension UINavigationController {
    

    func setExpansionBackbuttonArea() {
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "                             "
        backButton.tintColor = .red
        
        self.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}
