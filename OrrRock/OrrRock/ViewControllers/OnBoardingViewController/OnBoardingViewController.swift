//
//  OnBoardingViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/26.
//

import UIKit

class OnBoardingViewController: UIViewController , UISheetPresentationControllerDelegate{

    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.text = "오르락 시작하기"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        // Do any additional setup after loading the view.
    }
    

    private func setUpDelegate(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [.large()]
    }

}
