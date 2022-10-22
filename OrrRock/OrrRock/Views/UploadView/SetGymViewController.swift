//
//  SetGymViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//

import PhotosUI
import UIKit

import NVActivityIndicatorView
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

    //인디게이터 사용을 위한 선언
    private let indicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150),
                                           type: .lineSpinFadeLoader,
                                           color: .lightGray,
                                           padding: 50)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    //인디게이터가 돌 때 다른 동작을 못하게 하기위한 뷰
    private lazy var blockTouchView: UIView = {
        let view = UIView()
        
        return view
    }()

//MARK: 생명주기 함수 모음
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupLayout()
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
//        configuration.preferredAssetRepresentationMode = .current
        configuration.filter = .any(of: [.videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    //터치를 제한하는 뷰를 추가하고 인디게이터를 실행 시킵니다.
    func startIndicator() {
        addBlockTouchView()
        indicator.startAnimating()
    }
    
    func stopIndicator() {
        self.indicator.stopAnimating()
        blockTouchView.removeFromSuperview()
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

        // 인디게이터 위치 추가
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }

    }

    //이친구는 반복적으로 추가되고 삭제 되어야해서 따로 만들었습니다.
    func addBlockTouchView() {
        self.view.addSubview(blockTouchView)
        blockTouchView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.trailing.equalTo(view.snp.trailing)
            $0.leading.equalTo(view.snp.leading)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
}

extension SetGymViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var videoUrlArray: [URL] = []
        //인디케이트를 소환합니다.
        startIndicator()
        
        //사용자가 영상을 선택 하지 않은 상태일 때
        if results.count == 0 {
            //인디게이터 종료
            stopIndicator()
        }
        
        //선택된 영상에서 URL을 뽑아내는 로직입니다.
        for i in 0..<results.count {
            results[i].itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, err in
                if url == nil {
                    NSLog("Orr_HomeViewController_Err1:\(String(describing: err))\n")
                } else {
                    videoUrlArray.append(url!)
                }

                if results.count - 1 == i {
                    DispatchQueue.main.sync {
                        //인디케이터 종료
                        self.stopIndicator()
                        let nextVC = UpoadTestNextViewController()
                        nextVC.viewUrlArray = videoUrlArray
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
    }
}


class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .brown
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
