//
//  RouteFindingFeatureViewController+UIPageViewExtensions.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/30.
//

import UIKit

extension RouteFindingFeatureViewController: UIPageViewControllerDataSource {
    // 이전 페이지로 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pageViewControllerList.firstIndex(of: viewController as! RouteFindingPageViewController) else { return nil }
                
        // 현재 페이지가 0번째 페이지라면 이동하지 않음
        let prevIndex = currentIndex - 1
        guard prevIndex >= 0,
              pageViewControllerList.count > prevIndex else { return nil }
        
        return pageViewControllerList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pageViewControllerList.firstIndex(of: viewController as! RouteFindingPageViewController) else { return nil }
        
        // 현재 페이지가 마지막 페이지라면 이동하지 않음
        let nextIndex = currentIndex + 1
        guard nextIndex >= 0,
              pageViewControllerList.count > nextIndex else { return nil }
        

        return pageViewControllerList[nextIndex]
    }
}

extension RouteFindingFeatureViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingIndex = pageViewControllerList.firstIndex(of: pendingViewControllers.first! as! RouteFindingPageViewController )
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                              didFinishAnimating finished: Bool,
                              previousViewControllers: [UIViewController],
                              transitionCompleted completed: Bool) {
        guard completed,
          let currentVC = pageViewController.viewControllers?.first,
              let index = pageViewControllerList.firstIndex(of: currentVC as! RouteFindingPageViewController) else { return }
      }
}
