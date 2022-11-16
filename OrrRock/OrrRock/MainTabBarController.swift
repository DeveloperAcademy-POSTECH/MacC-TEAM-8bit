//
//  MainTabBarController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/16.
//

import UIKit

import SnapKit

class MainTabBarController: UIViewController {
    
    private let myPageViewController = UIViewController()
    private let homeViewController = HomeViewController()
    private let routeFindingController = UIViewController()
    
    let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
        setUpLayout()
        
    }
    
    func setUpTabBar() {
        
        
        
        
    }
    
    func setUpLayout() {
        self.view.addSubview(tabBar.view)
    }
}

