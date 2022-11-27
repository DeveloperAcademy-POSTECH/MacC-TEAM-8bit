//
//  RouteFindingSixthOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingSixthOnboardingViewController: RouteFindingOnboardingParentViewController {

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
        
        descriptionView.text = "추가한 시퀀스는 꾸욱 눌러\n삭제할 수 있어요"
    }
    
    // MARK: Functions
    
    // MARK: @objc Functions
}
    


extension RouteFindingSixthOnboardingViewController {
    
    // MARK: Set Up Functions

}

