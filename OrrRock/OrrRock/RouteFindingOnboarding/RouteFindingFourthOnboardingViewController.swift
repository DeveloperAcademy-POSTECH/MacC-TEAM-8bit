//
//  RouteFindingFourthOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingFourthOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables

    
    // MARK: View Components
    
    override var descriptionView: UILabel {
        get { return super.descriptionView }
        set { self.descriptionView = newValue }
    }
    
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionView.text = "동작을 살짝 눌러\n힘의 방향을 기록할 수 있어요"
    }
    
    // MARK: Functions
    
    // MARK: @objc Functions
}

    

extension RouteFindingFourthOnboardingViewController {
    
    // MARK: Set Up Functions
    
    override func setUpLayout() {
        super.setUpLayout()
        

    }
}
