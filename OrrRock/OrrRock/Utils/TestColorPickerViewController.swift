//
//  TestColorPickerViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/23.

import UIKit
import SnapKit

// MARK:  꼬마가 작업하기 위한 테스트 뷰입니다. 테스트가 끝나면 삭제해주세요.
class TestColorPickerViewController: UIViewController {

    
    private lazy var colorPickerView: ColorPickerView = {
        let view = ColorPickerView()
        //배열에서 선택되어야 하는값
        view.pickerSelectValue = 99
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        view.backgroundColor = .brown
        // Do any additional setup after loading the view.
    }

}

extension TestColorPickerViewController : ColorPickerViewDelegate{
    func didColorChanged(selectedColor: UIColor) {
        view.backgroundColor = selectedColor
    }
}

extension TestColorPickerViewController {
    
    private func setUpLayout(){
        view.addSubview(colorPickerView)
        colorPickerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}
