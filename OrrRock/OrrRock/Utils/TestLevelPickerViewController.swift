//
//  TestLevelPickerViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/19.
//

import UIKit
import SnapKit

class TestLevelPickerViewController: UIViewController{

    var pickerWidth = 48 + 16
    var pickerSelectValue = 0
     let levelValues: [Int] = [-1,0,1,2,3,4,5,6,7,8,9]
//    let levelValues = ["0","0","0","0","0","0",]

    var selectLevel : Int?
    var rotationAngle: CGFloat! = -90  * (.pi/180)

    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 180.0)
        picker.backgroundColor = .orrGray1
        picker.delegate = self
        picker.dataSource = self
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        return picker
    }()
    
    override func viewDidLayoutSubviews() {
        //피커뷰 회색 증발 마술
        pickerView.subviews[1].isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        self.pickerView.delegate?.pickerView?(self.pickerView, didSelectRow: pickerSelectValue, inComponent: 0)
        self.pickerView.selectRow(pickerSelectValue, inComponent: 0, animated: true)
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.height.equalTo(view.snp.height)
            $0.width.equalTo(pickerWidth)
            $0.center.equalTo(view.center)
        }

    }
    
}

extension TestLevelPickerViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectLevel = row - 1
        guard let view = pickerView.view(forRow: row, forComponent: component) else {
            return
        }
            view.subviews[0].backgroundColor = .orrUPBlue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levelValues[row] == -1 ? "선택안함" : "V\(levelValues[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let pickerRow = UIView()
        pickerRow.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: 32)


        let rowLabel = UILabel()
        rowLabel.textColor = .black
//        rowLabel.text = "\(levelValues[row])"
        rowLabel.text = "V1"
        rowLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)

        rowLabel.textAlignment = .center
        rowLabel.layer.borderWidth = 1.0
        rowLabel.layer.cornerRadius = 15
        rowLabel.layer.masksToBounds = true
        rowLabel.layer.borderColor = UIColor.orrGray3?.cgColor

        pickerRow.addSubview(rowLabel)
        rowLabel.snp.makeConstraints {
            $0.leading.equalTo(pickerRow.snp.leading).offset(8)
            $0.trailing.equalTo(pickerRow.snp.trailing).offset(-8)
            $0.height.equalTo(pickerRow.snp.height)
        }

        pickerRow.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return pickerRow
    }
    
    //피커의 높이 (지금은 넓이)
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(pickerWidth)
    }


    
}
