//
//  OnBoardingViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/08.
//

import UIKit

class OnBoardingViewController: UIPageViewController {
    
    lazy var vcArray: [UIViewController] = {
        return [OnBoardingViewControllerFirst(),
                OnBoardingViewControllerSecond(),
                OnBoardingViewControllerThird()]
    }()
    
    lazy var pageControl : UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.alpha = 0.5
        control.tintColor = UIColor.black
        control.pageIndicatorTintColor = UIColor.gray
        control.currentPageIndicatorTintColor = UIColor.black
        return control
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchDown)
        btn.setTitle("계속", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    var currentIndex: Int?
    var pendingIndex: Int?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setLayout()
    }
}

extension OnBoardingViewController : UIPageViewControllerDelegate {
    
    private func setLayout() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(158)
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).offset(-34)
            $0.leading.equalTo(view).offset(OrrPadding.padding3.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPadding.padding3.rawValue)
            $0.height.equalTo(56)
        }
    }
    
    func setDelegate(){
        self.delegate = self
        self.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    @objc
    private func pressNextButton(_ sender: UIButton) {
        self.goToNextPage()
        if pageControl.currentPage == 2 {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.popToRootViewController(animated: false)
            UserDefaults.standard.set(true, forKey: "watchOnBoard")
            
        }
        pageControl.currentPage += 1
        //이동
    }
    
}

extension OnBoardingViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        let prevIndex = vcIndex - 1
        guard prevIndex >= 0 else {
            return nil
        }
        guard vcArray.count > prevIndex else { return nil }
        return vcArray[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard nextIndex < vcArray.count else {
            return nil
        }
        guard vcArray.count > nextIndex else { return nil }
        return vcArray[nextIndex]
    }
    //MARK: 기본 인디케이터 사용시 코드 - 혹시 몰라서 일단 남겨놓음
    //    func presentationCount(for pageViewController: UIPageViewController) -> Int {
    //        let appearance = UIPageControl.appearance()
    //        appearance.pageIndicatorTintColor = UIColor.gray
    //        appearance.currentPageIndicatorTintColor = UIColor.white
    //        appearance.backgroundColor = UIColor.darkGray
    //        return 3
    //    }
    //
    //    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    //        return 0
    //    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = vcArray.firstIndex(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}

extension UIPageViewController {
    
    func goToNextPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func goToPreviousPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
    }
    
}
