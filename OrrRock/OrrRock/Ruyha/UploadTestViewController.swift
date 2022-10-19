//
//  UploadTestView.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/19.
//

import UIKit
import SnapKit
import PhotosUI

import NVActivityIndicatorView

class UploadTestViewController: UIViewController {
    
    //MARK: View에 추가를 해야하는 것들을 선언합니다.
    //인디게이터 사용을 위한 선언
    let indicator : NVActivityIndicatorView = {
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
    
    //추후 홈 화면 하단에 버튼을 생성한다면 이 버튼은 삭제 하셔야 합니다.
    let testButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("테스트 버튼.", for: .normal)
        btn.setTitleColor(.red, for: .focused)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(testButtonPressed), for: .touchDown)
        btn.layer.cornerRadius = 20
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: View의 생명주기 함수들이 있는 영역입니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addTestBtn()
        addIndicator()
    }
    
}


//MARK: SnapKit관련 함수들입니다.
extension UploadTestViewController{
    func addTestBtn(){
        self.view.addSubview(testButton)
        testButton.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.bottom.equalTo(view.safeAreaInsets.bottom).offset(-20)
        }
    }
    
    func addIndicator(){
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view)
            
        }
    }
}

//MARK: 버튼 클릭 등 이벤트 관련 함수들입니다.
extension UploadTestViewController{
    
    @objc func testButtonPressed(sender: UIButton!) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        //인디게이터 도는거 보고 싶으면 아랫줄을 주석 처리해주세요.
        configuration.preferredAssetRepresentationMode = .current
        configuration.filter = .any(of: [.videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

extension UploadTestViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var myArray: [URL] = []
        //인디케이트를 소환합니다.
        indicator.startAnimating()
        
        //사용자가 영상을 선택 하지 않은 상태일 때
        if results.count == 0{
                //인디케이터를 숨깁니다.
                self.indicator.stopAnimating()
        }
        
        //선택된 영상에서 URL을 뽑아내는 로직이빈다.
        for i in 0..<results.count {
            results[i].itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, err in
                if url != nil {
                    myArray.append(url!)
                    if results.count == myArray.count{
                        DispatchQueue.main.sync {
                            //인디케이터를 숨깁니다.
                            self.indicator.stopAnimating()
                            self.navigationController?.pushViewController(UpoadTestNextViewController(), animated: true)
                        }
                    }
                }
            }
        }
    }

}
