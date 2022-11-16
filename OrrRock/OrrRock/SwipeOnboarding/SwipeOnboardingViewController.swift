//
//  SwipeOnboardingViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/16.
//

import UIKit
import SnapKit

protocol SwipeOnboardingViewControllerDelegate {
    func changeNextView()
}

class SwipeOnboardingViewController: UIPageViewController {

    var currentIndex: Int?
    var pendingIndex: Int?
    var index = 0
    //MARK: Ruyha Test
    var firstView : SwipeOnboardingFirstViewController = {
        let vc = SwipeOnboardingFirstViewController()
        vc.ppap1()
        return vc
    }()
    
    
    var secondView : SwipeOnboardingFirstViewController = {
        let vc = SwipeOnboardingFirstViewController()
        vc.ppap2()
        return vc
    }()
    
    var thirdView : SwipeOnboardingFirstViewController = {
        let vc = SwipeOnboardingFirstViewController()
        vc.ppap3()
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstView.delegate = self
        secondView.delegate = self
        thirdView.delegate = self
        setDelegate()
        }
    
    lazy var vcArray: [SwipeOnboardingFirstViewController] = {
        return [firstView,secondView,thirdView]
    }()
}

extension SwipeOnboardingViewController : SwipeOnboardingViewControllerDelegate {
    func changeNextView() {
        print("ppap:??")
        self.goToNextPage()
    }
}

extension SwipeOnboardingViewController : UIPageViewControllerDelegate {
    func setDelegate(){
        self.delegate = self
        self.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }

}

extension SwipeOnboardingViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController as! SwipeOnboardingFirstViewController) else { return nil }
        let prevIndex = vcIndex - 1
        guard prevIndex >= 0 else {
            return nil
        }
        guard vcArray.count > prevIndex else { return nil }
        return vcArray[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController as! SwipeOnboardingFirstViewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard nextIndex < vcArray.count else {
            return nil
        }
        guard vcArray.count > nextIndex else { return nil }
        return vcArray[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = vcArray.firstIndex(of: pendingViewControllers.first! as! SwipeOnboardingFirstViewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
        }
    }
}
