//
//  ViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/18.
//

import UIKit
import SnapKit
class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewController 생성
        // TODO: 새로운 뷰 작업시 이곳에 ViewController 연결하기
        let myActivityViewController = MyActivityViewController()
        let homeViewController = HomeViewController()
//        let routeFindingController = UIViewController()
        
        // Tab Bar의 아이템 생성
        let myActivityItem = UITabBarItem(title: "내 활동", image: UIImage(named: "tabbar mypage icon"), tag: 0)
        let homeItem = UITabBarItem(title: "기록", image: UIImage(named: "tabbar home icon"), tag: 1)
//        let routeFindingItem = UITabBarItem(title: "루트파인딩", image: UIImage(named: "tabbar routefinding icon"), tag: 2)
        
        // 각 뷰 컨트롤러에 아이템 할당
        myActivityViewController.tabBarItem = myActivityItem
        homeViewController.tabBarItem = homeItem
//        routeFindingController.tabBarItem = routeFindingItem
        
        // 생성한 ViewController들을 Tab Bar에 할당
        self.setViewControllers([myActivityViewController,
                                   homeViewController,
                                   /*routeFindingController*/], animated: true)

        // Tab Bar 아이템의 색상 설정
        self.tabBar.tintColor = .orrUPBlue!
        
        // 기본 페이지를 homeVC로 설정
        self.selectedIndex = 1
    }
}

