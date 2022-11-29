//
//  RouteFindingDetailViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/29.
//

import UIKit

class RouteFindingDetailViewController: UIViewController {

    // MARK: Variables
//    var routeFindingInformation: RouteInfo
    
    // MARK: View Components
    
    private lazy var routePageViewController: UIPageViewController = {
        let VC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        return VC
    }()
    
    private lazy var topSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        return view
    }()
    
    private lazy var bottomSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrWhite
        return view
    }()
    
    private lazy var routeInfoView: RouteInfoView = {
        let view = RouteInfoView()
        
        return view
    }()
    // MARK: Life Cycle Functions
    
    
    // MARK: Functions
    
    
    // MARK: @objc Functions
    

}

extension RouteFindingDetailViewController {
    
    // MARK: Set Up Functions
    private func setUpLayout() {
        view.addSubview(topSafeAreaView)
        topSafeAreaView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.top.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
//         하단 safe area를 가려주는 뷰
        view.addSubview(bottomSafeAreaView)
        bottomSafeAreaView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.bottom.equalTo(self.view)
        }
        
        view.addSubview(routeInfoView)
        routeInfoView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.height.equalTo(650)
            $0.bottom.equalTo(self.view).offset(650)
        }
    }
    
}
