//
//  RootFindingSaveViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/25.
//

import UIKit

class RootFindingSaveViewController: UIViewController {
    
    private var goBackButton: UIBarButtonItem!
    private var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        self.view.backgroundColor = .orrBlack
    }
    
    func setNavigationBar() {
        goBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBackAction))
        saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"), style: .plain, target: self, action: #selector(saveAction))
        
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnTap = true
        
        navigationItem.leftBarButtonItem = goBackButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAction() {
        // TODO: 사진 앱에 사진 저장하는 로직 추가
    }
}
