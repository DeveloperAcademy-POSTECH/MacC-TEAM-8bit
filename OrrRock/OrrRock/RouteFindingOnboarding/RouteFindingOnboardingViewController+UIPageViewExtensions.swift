//
//  RouteFindingOnboardingViewController+UIPageViewExtensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

extension RouteFindingOnboardingViewController: UIPageViewControllerDataSource {
    // 이전 페이지로 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        
        // 현재 페이지가 0번째 페이지라면 이동하지 않음
        let prevIndex = currentIndex - 1
        guard prevIndex >= 0,
              viewControllerList.count > prevIndex else { return nil }
        
        return viewControllerList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        
        // 현재 페이지가 마지막 페이지라면 이동하지 않음
        let nextIndex = currentIndex + 1
        guard nextIndex >= 0,
              viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
    }
}

extension RouteFindingOnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingIndex = viewControllerList.firstIndex(of: pendingViewControllers.first! )
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = self.pendingIndex!
        }
    }
}
