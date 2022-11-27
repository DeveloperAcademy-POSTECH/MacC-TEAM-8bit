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
            return viewController
        }()
        
        let secondViewController: RouteFindingSecondOnboardingViewController = {
            let viewController = RouteFindingSecondOnboardingViewController(backgroundImage: backgroundImage)
            return viewController
        }()
        
        let thirdViewController: RouteFindingThirdOnboardingViewController = {
            let viewController = RouteFindingThirdOnboardingViewController(backgroundImage: backgroundImage)
            return viewController
        }()
        
        let fourthViewController: RouteFindingFourthOnboardingViewController = {
            let viewController = RouteFindingFourthOnboardingViewController(backgroundImage: backgroundImage)
            return viewController
        }()
        
        let fifthViewController: RouteFindingFifthOnboardingViewController = {
            let viewController = RouteFindingFifthOnboardingViewController(backgroundImage: backgroundImage)
            
            return viewController
        }()
        
        let sixthViewController: RouteFindingSixthOnboardingViewController = {
            let viewController = RouteFindingSixthOnboardingViewController(backgroundImage: backgroundImage)
            
            return viewController
        }()
        
        let seventhViewController: RouteFindingSeventhOnboardingViewController = {
            let viewController = RouteFindingSeventhOnboardingViewController(backgroundImage: backgroundImage)
            
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
        print("DEBUG PGAE")
    }
    
    func skipOnboarding() {
        print("DEBUG PGAE")
    }
    
    
}
