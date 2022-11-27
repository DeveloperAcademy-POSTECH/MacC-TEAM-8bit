//
//  RouteFindingOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

protocol RouteFindingOnboardingPaginationDelegate {
    func moveToNextPage()
    func skipOnboarding()
}

class RouteFindingOnboardingViewController: UIPageViewController {
    
    // MARK: Variables
    
    let backgroundImage: UIImage
    
    var currentIndex: Int = 0
    var pendingIndex: Int?
    
    lazy var viewControllerList: [UIViewController] = {
        let firstViewController: RouteFindingFirstOnboardingViewController = {
            let viewController = RouteFindingFirstOnboardingViewController(backgroundImage: backgroundImage)
            viewController.delegate = self
            return viewController
        }()
        
        let secondViewController: RouteFindingSecondOnboardingViewController = {
            let viewController = RouteFindingSecondOnboardingViewController(backgroundImage: backgroundImage)
            viewController.delegate = self
            return viewController
        }()
        
        let thirdViewController: RouteFindingThirdOnboardingViewController = {
            let viewController = RouteFindingThirdOnboardingViewController(backgroundImage: backgroundImage)
            viewController.delegate = self
            return viewController
        }()
        
        let fourthViewController: RouteFindingFourthOnboardingViewController = {
            let viewController = RouteFindingFourthOnboardingViewController(backgroundImage: backgroundImage)
            viewController.delegate = self
            return viewController
        }()
        
        let fifthViewController: RouteFindingFifthOnboardingViewController = {
            let viewController = RouteFindingFifthOnboardingViewController(backgroundImage: backgroundImage)
            viewController.delegate = self
            return viewController
        }()
        
        let sixthViewController: RouteFindingSixthOnboardingViewController = {
            let viewController = RouteFindingSixthOnboardingViewController(backgroundImage: backgroundImage)
            viewController.delegate = self
            return viewController
        }()
        
        let seventhViewController: RouteFindingSeventhOnboardingViewController = {
            let viewController = RouteFindingSeventhOnboardingViewController(backgroundImage: backgroundImage)
            viewController.delegate = self
            return viewController
        }()
        
        return [firstViewController, secondViewController, thirdViewController, fourthViewController, fifthViewController, sixthViewController, seventhViewController]
    }()
    
    
    // MARK: View Components
    
    
    
    // MARK: Life Cycle Functions
    
    init(backgroundImage: UIImage) {
        self.backgroundImage = backgroundImage
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        if let firstVC = viewControllerList.first {
            setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
        view.backgroundColor = .orrWhite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Functions
    
    // MARK: @objc Functions
}

    

extension RouteFindingOnboardingViewController {
    
    // MARK: Set Up Functions
    func setUpDelegate() {
        self.delegate = self
        self.dataSource = self
    }
    
    func setUpPageViewController() {
        
    }
}

extension RouteFindingOnboardingViewController: RouteFindingOnboardingPaginationDelegate {
    func moveToNextPage() {
        guard let currentVC = self.viewControllerList.first,
              let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC) else { return }
        
        setViewControllers([nextVC], direction: .forward, animated: true)
    }
    
    func skipOnboarding() {
        UserDefaults.standard.set(true, forKey: "RouteFindingOnboardingClear")
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
}
