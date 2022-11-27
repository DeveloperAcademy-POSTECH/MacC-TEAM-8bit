//
//  RouteFindingFifthOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingFifthOnboardingViewController: RouteFindingOnboardingParentViewController {
    
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
        
        descriptionView.text = "+를 눌러\n다음 동작을 기록할 수 있는 페이지를 추가할 수 있어요"
    }
    
    
    // MARK: Functions
    
    // MARK: @objc Functions
}

    

extension RouteFindingFifthOnboardingViewController {
    
    // MARK: Set Up Functions

}
