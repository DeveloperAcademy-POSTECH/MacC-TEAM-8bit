//
//  ViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/18.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var testButton : UIButton = {
        let button = UIButton()
        button.setTitle("gotoalbum", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }


}

