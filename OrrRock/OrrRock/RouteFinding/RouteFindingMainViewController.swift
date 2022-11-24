//
//  ViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/24.
//

import UIKit
import SnapKit

class RouteFindingMainViewController: UIViewController {

    
    lazy var topView : UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "루트 파인딩"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    lazy var plusButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)), for: .normal)
        button.tintColor = .orrGray600
        return button
    }()
    
    lazy var routeFindingPageViewController = rou
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func setUpLayout(){
        view.backgroundColor = .orrGray100
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.forLastBaselineLayout.snp_topMargin).offset(OrrPd.pd8.rawValue)
            $0.width.equalToSuperview()
            $0.height.equalTo(26)
        }
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(OrrPd.pd16.rawValue)
        }
        topView.addSubview(plusButton)
        plusButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-OrrPd.pd16.rawValue)
        }
        view.addSubview()
        
    }
    
    func setNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
}
