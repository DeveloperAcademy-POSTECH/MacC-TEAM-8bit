//
//  SetGymViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//

import PhotosUI
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
        view.font = UIFont.systemFont(ofSize: 22)
        view.addTarget(self, action: #selector(nextBttonOnAndOff(textField:)), for: .editingChanged)
        return view
    }()

    let nextButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
        btn.setBackgroundColor(.orrGray2!, for: .disabled)
        btn.addTarget(self, action: #selector(nextButtonPressed), for: .touchDown)
        btn.setTitle("저장", for: .normal)
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

    override func viewWillAppear(_ animated: Bool) {
        gymTextField.becomeFirstResponder()
    }
}

//MARK: 함수모음
extension SetGymViewController {

    //텍스트 필드의 내용물에 따라 버튼을 활성화 비활성화 시킴
    @objc final private func nextBttonOnAndOff(textField: UITextField) {
        if textField.text != "" {
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false
        }
    }

    @objc func nextButtonPressed(sender: UIButton!) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        //인디게이터 도는거 보고 싶으면 아랫줄을 주석 처리해주세요.
        configuration.preferredAssetRepresentationMode = .current
        configuration.filter = .any(of: [.videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        self.view.endEditing(true)
    }

}

//MARK: 오토레이아웃 설정 영역
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

extension SetGymViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        var videoUrlArray: [URL] = []
        //인디케이트를 소환합니다.
        CustomIndicator.startLoading()
        //사용자가 영상을 선택 하지 않은 상태일 때
        if results.count == 0 {
            //인디게이터 종료
            CustomIndicator.stopLoading()
            gymTextField.becomeFirstResponder()
        }

        //선택된 영상에서 URL을 뽑아내는 로직입니다.
        for index in 0..<results.count {
            results[index].itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, err in
                if url == nil {
                    NSLog("Orr_HomeViewController_Err1:\(String(describing: err))\n")
                } else {
                    videoUrlArray.append(url!)
                }

                if results.count - 1 == index {
                    DispatchQueue.main.sync {
                        //인디케이터 종료
                        CustomIndicator.stopLoading()
                        let nextVC = UpoadTestNextViewController()
                        nextVC.viewUrlArray = videoUrlArray
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
    }
}
