//
//  OnBoardigSuperViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/15.
//

import UIKit
import SnapKit

class OnBoardigSuperViewController: UIViewController {
    
    var titleLabelText = ""
    var subLabelText = ""
    var labelImageName = ""
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .orrBlack
        label.text = titleLabelText
        return label
    }()
    
    private lazy var paddigView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .orrBlack
        label.textAlignment = .center
        label.text = subLabelText
        return label
    }()
    
    private lazy var labelImage: UIImageView = {
        let image = UIImage(named: labelImageName)
        let label = UIImageView(image: image)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    private func setUpLayout() {
        view.backgroundColor = .orrWhite
        
        view.addSubview(labelImage)
        labelImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(self.view.snp.leading).offset(OrrPd.pd20.rawValue)
            $0.trailing.equalTo(self.view.snp.trailing).offset(-OrrPd.pd20.rawValue)
            $0.height.equalTo(labelImage.snp.width).multipliedBy(1.1)
        }
        
        view.addSubview(paddigView)
        paddigView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(labelImage.snp.top)
        }
        
        paddigView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(paddigView)
            $0.bottom.equalTo(paddigView.snp.centerY).offset(-OrrPd.pd4.rawValue)
        }
        
        paddigView.addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.centerX.equalTo(paddigView)
            $0.top.equalTo(paddigView.snp.centerY).offset(OrrPd.pd4.rawValue)
        }
        
    }
}
