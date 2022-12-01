//
//  RoutefindingDetailViewController+UIPageViewControllerDelegate.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/30.
//

import UIKit

extension RouteFindingDetailViewController: UIPageViewControllerDataSource {
    // 이전 페이지로 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = viewControllerListForPageVC.firstIndex(of: viewController) else { return nil }
                
        // 현재 페이지가 0번째 페이지라면 이동하지 않음
        let prevIndex = currentIndex - 1
        guard prevIndex >= 0,
              viewControllerListForPageVC.count > prevIndex else { return nil }
        
        return viewControllerListForPageVC[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerListForPageVC.firstIndex(of: viewController) else { return nil }
        
        // 현재 페이지가 마지막 페이지라면 이동하지 않음
        let nextIndex = currentIndex + 1
        guard nextIndex >= 0,
              viewControllerListForPageVC.count > nextIndex else { return nil }
        

        return viewControllerListForPageVC[nextIndex]
    }
}

extension RouteFindingDetailViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingIndex = viewControllerListForPageVC.firstIndex(of: pendingViewControllers.first! )
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                              didFinishAnimating finished: Bool,
                              previousViewControllers: [UIViewController],
                              transitionCompleted completed: Bool) {
        guard completed,
          let currentVC = pageViewController.viewControllers?.first,
          let index = viewControllerListForPageVC.firstIndex(of: currentVC) else { return }
        
//        print("index : \(index)")
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)

      }
}

