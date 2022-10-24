//
//  ViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/18.
//

import UIKit
import SnapKit
class MainViewController: UIViewController {
    
    //테스트코드
    private lazy var testButton : UIButton = {
        let button = UIButton()
        button.setTitle("gotoalbum", for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        //테스트코드
        view.addSubview(testButton)
        testButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        testButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    //테스트 코드
    @objc func buttonAction(sender: UIButton!) {
        let nextVC = VideoCollectionViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

