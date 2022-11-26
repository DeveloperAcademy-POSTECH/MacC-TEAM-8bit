//
//  OnBoardingViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/08.
//

import UIKit

class OnBoardingViewController: UIPageViewController {
    
    var firstView : OnBoardigSuperViewController = {
        let vc = OnBoardigSuperViewController()
        vc.titleLabelText = "오르락과 함께"
        vc.subLabelText = "볼더링 클라이밍을 즐겨요"
        vc.labelImageName = "OnboardingImage1"
        return vc
    }()
    
    var secondView : OnBoardigSuperViewController = {
        let vc = OnBoardigSuperViewController()
        vc.titleLabelText = "홀드를 잡고 오르는"
        vc.subLabelText = "모습을 기록해서"
        vc.labelImageName = "OnboardingImage2"
        return vc
    }()
    
    var thirdView : OnBoardigSuperViewController = {
        let vc = OnBoardigSuperViewController()
        vc.titleLabelText = "더 높이, 더 어려운 문제에"
        vc.subLabelText = "함께 도전해요"
        vc.labelImageName = "OnboardingImage3"
        return vc
    }()
    
    lazy var vcArray: [OnBoardigSuperViewController] = {
        return [firstView,secondView,thirdView]
    }()
    
    lazy var pageControl : UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.alpha = 0.5
//        control.tintColor = .red //UIColor.orrBlack
        control.pageIndicatorTintColor = .orrGray300//UIColor.gray
        control.currentPageIndicatorTintColor = .orrBlack//UIColor.black
        control.backgroundColor = .clear
        return control
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        btn.setTitle("계속", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
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
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd16.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-OrrPd.pd16.rawValue)
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
        guard let vcIndex = vcArray.firstIndex(of: viewController as! OnBoardigSuperViewController) else { return nil }
        let prevIndex = vcIndex - 1
        guard prevIndex >= 0 else {
            return nil
        }
        guard vcArray.count > prevIndex else { return nil }
        return vcArray[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController as! OnBoardigSuperViewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard nextIndex < vcArray.count else {
            return nil
        }
        guard vcArray.count > nextIndex else { return nil }
        return vcArray[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = vcArray.firstIndex(of: pendingViewControllers.first! as! OnBoardigSuperViewController)
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
