//
//  SetGymViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//

import UIKit

import SnapKit

class SetGymViewController: UIViewController {

    let gymNameLabel : UILabel = {
        let label = UILabel()
        label.text = "해당 암장의 이름을 적어주세요"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .orrBlack
        label.backgroundColor = .orrWhite
        return label
    }()

    let gymTextField : UnderlinedTextField = {
        let view = UnderlinedTextField()
        view.borderStyle = .none
        view.placeholder = "클라이밍장"
        view.tintColor = .orrUPBlue
        view.addTarget(self, action: #selector(nextBttonOnAndOff(textField:)), for: .editingChanged)
        return view
    }()

    let nextButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
//        btn.addTarget(self, action: #selector(nextButtonPressed), for: .touchDown)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupLayout()
        gymTextField.becomeFirstResponder()
    }
    
    @objc final private func nextBttonOnAndOff(textField: UITextField) {
        if textField.text != "" {
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false
        }
    }
}

extension SetGymViewController {
    
    func setupLayout() {
    
        view.addSubview(gymNameLabel)
        gymNameLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(orrPadding.padding5.rawValue)
        }

        view.addSubview(gymTextField)
        gymTextField.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.top.equalTo(gymNameLabel.snp.bottom).offset(orrPadding.padding7.rawValue)
            $0.leading.equalTo(view).offset(orrPadding.padding6.rawValue)
            $0.trailing.equalTo(view).offset(-orrPadding.padding6.rawValue)
        }

        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(56)
        }

    }
    
}
