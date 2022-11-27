//
//  RouteFindingThirdOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingThirdOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables

    
    // MARK: View Components
    
    private lazy var deleteIcon: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "delete")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
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
        
        descriptionView.text = "추가된 동작을 꾸욱 눌러\n이동 및 삭제할 수 있어요"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Functions
    
    // MARK: @objc Functions
}

    

extension RouteFindingThirdOnboardingViewController {
    
    // MARK: Set Up Functions

    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(deleteIcon)
        deleteIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(super.descriptionView.snp.top).offset(-OrrPd.pd40.rawValue)
            $0.width.height.equalTo(56)
        }
    }
}
