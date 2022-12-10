//
//  DateSettingViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//  

import UIKit

import SnapKit

class DateSettingViewController: UIViewController {
    
    var gymVisitDate = Date()
    
    let datePickerLabel : UILabel = {
        let label = UILabel()
        label.text = "방문한 날짜를 알려주세요"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .orrBlack
        label.backgroundColor = .orrWhite
        return label
    }()
    
    let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.locale = Locale(identifier:"ko_KR")
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        datePicker.backgroundColor = .orrWhite
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    let nextButton : UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray300!, for: .disabled)
        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        btn.setTitle("계속", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()

    //MARK: 생명주기 함수 모음
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orrWhite
        self.navigationController?.setExpansionBackbuttonArea()
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

//MARK:  @objc 함수모음
extension DateSettingViewController {
    
    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        self.gymVisitDate = sender.date
    }
    
    @objc
    private func pressNextButton(_ sender: UIButton) {
        let nextVC = GymSettingViewController()
        nextVC.gymVisitDate = gymVisitDate
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//MARK: 오토레이아웃 설정 영역
extension DateSettingViewController {
    
    func setUpLayout() {
        
        view.addSubview(datePickerLabel)
        datePickerLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(OrrPd.pd16.rawValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(OrrPd.pd24 .rawValue)
        }
        
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.top.equalTo(datePickerLabel.snp.bottom).offset(OrrPd.pd24.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-OrrPd.pd16.rawValue)
            $0.leading.equalTo(view).offset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
    }
    
}
