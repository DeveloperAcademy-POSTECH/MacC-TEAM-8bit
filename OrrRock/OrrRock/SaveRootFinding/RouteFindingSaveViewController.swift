//
//  RouteFindingSaveViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/25.
//

import UIKit
import SnapKit

class RouteFindingSaveViewController: UIViewController {
    
    private var goBackButton: UIBarButtonItem!
    private var saveButton: UIBarButtonItem!
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
//        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        
        return btn
    }()
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
//        btn.addTarget(self, action: #selector(pressSkipButton), for: .touchUpInside)
        btn.setAttributedTitle("저장하지 않을래요".underLineAttribute(), for: .normal)
        
        return btn
    }()
    
    private lazy var countVideoView:  UIView = {
        let view = UIView()
        view.backgroundColor = .orrBlack?.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    lazy var countVideoLabel: UILabel = {
        let label = UILabel()
        label.text = "12/20"  // FIXME: 수정
        label.textColor = .orrWhite
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUpLayout()
        
        navigationController?.isToolbarHidden = true
        navigationController?.hidesBarsOnTap = false
        
        self.view.backgroundColor = .orrBlack
    }
    
    func viewWillDisappear() {
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnTap = true

    }
    
    func setNavigationBar() {
        goBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBackAction))
        goBackButton.tintColor = .orrWhite
        saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"), style: .plain, target: self, action: #selector(saveAction))
        saveButton.tintColor = .orrWhite
        
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

extension RouteFindingSaveViewController {
    
    private func setUpLayout() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).inset(OrrPd.pd36.rawValue)
            $0.leading.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(nextButton.snp.top).offset(-OrrPd.pd8.rawValue)
        }
        
        view.addSubview(countVideoView)
        countVideoView.snp.makeConstraints {
            $0.bottom.equalTo(skipButton.snp.top).offset(-OrrPd.pd36.rawValue)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(71)
        }
        
        countVideoView.addSubview(countVideoLabel)
        countVideoLabel.snp.makeConstraints {
            $0.center.equalTo(countVideoView.snp.center)
        }
    }
}
