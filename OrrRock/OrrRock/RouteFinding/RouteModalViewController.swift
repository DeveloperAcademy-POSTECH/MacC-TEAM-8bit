//
//  RouteModalViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/26.
//

import UIKit

class RouteModalViewController: UIViewController {

    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "sample"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setUpLayout(){
        view.backgroundColor = .orrWhite
        
    }
}
