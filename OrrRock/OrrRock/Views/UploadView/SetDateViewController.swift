//
//  SetDateViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//

import UIKit

import SnapKit

class SetDateViewController: UIViewController {

    let datePickerLabel : UILabel = {
        let label = UILabel()
        label.text = "업로드할 영상의 날짜를 선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 17)
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
        return datePicker
    }()

    let nextButton : UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.addTarget(self, action: #selector(nextButtonPressed), for: .touchDown)
        btn.setTitle("계속", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        return btn
    }()

//MARK: 생명주기 함수 모음
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orrWhite
        setupLayout()
    }

}

//MARK: 함수모음
extension SetDateViewController {

    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        print(sender.date)
        datePickerLabel.text = sender.date.timeToString()
        nextButton.isEnabled = true
    }

    @objc
    private func nextButtonPressed(_ sender: UIButton) {
        let nextVC = SetGymViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

//MARK: 오토레이아웃 설정 영역
extension SetDateViewController {

    func setupLayout() {

        view.addSubview(datePickerLabel)
        datePickerLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(orrPadding.padding5.rawValue)
        }

        view.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.top.equalTo(datePickerLabel.snp.bottom).offset(orrPadding.padding5.rawValue)
            $0.leading.equalTo(view).offset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(view).offset(-orrPadding.padding3.rawValue)
        }

        view.addSubview(nextButton)
        nextButton.snp.makeConstraints{
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view).offset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(view).offset(-orrPadding.padding3.rawValue)
            $0.height.equalTo(56)
        }
    }
}
