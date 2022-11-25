//
//  RootFindingSaveViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/25.
//

import UIKit

class RootFindingSaveViewController: UIViewController {
    
    private var goBackButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        self.view.backgroundColor = .orrBlack
    }
    
    func setNavigationBar() {
        goBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBackAction))
        
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnTap = true
        
        navigationItem.leftBarButtonItem = goBackButton
    }
    
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
