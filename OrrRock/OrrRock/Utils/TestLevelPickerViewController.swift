//
//  TestLevelPickerViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/19.
//

import UIKit
import SnapKit


protocol TestLevelPickerViewDelegate {
    func didLevelChanged(selectedLevel: Int)
}

class TestLevelPickerViewController: UIViewController{
    //피커뷰의 고정적으로 쓰이는 넓이
    var pickerWidth = 48 + 16
    //피커뷰가 시작 될때 선택 되어 있어야 하는 값
    var pickerSelectValue = 0
    
    //피커뷰에 들어갈 리스트들
    let levelValues: [Int] = [0,1,2,3,4,5,6,7,8,9]
    
    //피커가 선택한 레벨
    var selectLevel : Int?
    
    //회전각도
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    var delegate: TestLevelPickerViewDelegate?
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 180.0)
        picker.backgroundColor = .orrGray100
        picker.delegate = self
        picker.dataSource = self
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        return picker
    }()
    
    
    
    override func viewDidLayoutSubviews() {
        //피커뷰 회색 증발 마술
        pickerView.subviews[1].isHidden = true
       // setFirstSelectRowLabelColor(isFirst: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        view.backgroundColor = .red
        self.pickerView.delegate?.pickerView?(self.pickerView, didSelectRow: pickerSelectValue, inComponent: 0)
        pickerSelectValue =  pickerSelectValue < 0 ? 0 : pickerSelectValue
        //        self.pickerView.selectRow(pickerSelectValue + 1, inComponent: 0, animated: true)
        self.pickerView.selectRow(pickerSelectValue, inComponent: 0, animated: true)
    }
    
}


extension TestLevelPickerViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(pickerWidth)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectLevel = row
        guard let view = pickerView.view(forRow: row, forComponent: component) else {
            return
        }
        
        view.subviews[0].backgroundColor = .orrUPBlue
        //        delegate?.didLevelChanged(selectedLevel: selectLevel)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levelValues[row] == -1 ? "선택안함" : "V\(levelValues[row])"
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            
        let pickerRow = UIView()
        pickerRow.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: 32)
        
        lazy var rowLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 14, weight: .light)
            label.textAlignment = .center
            label.layer.borderWidth = 1.0
            label.layer.cornerRadius = 15
            label.layer.masksToBounds = true
            label.layer.borderColor = UIColor.orrGray400?.cgColor
            return label
        }()
        
        pickerRow.addSubview(rowLabel)
        rowLabel.snp.makeConstraints {
            $0.leading.equalTo(pickerRow.snp.leading).offset(8)
            $0.trailing.equalTo(pickerRow.snp.trailing).offset(-8)
            $0.height.equalTo(pickerRow.snp.height)
        }
        
        rowLabel.text = "\(levelValues[row])"
        pickerRow.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return pickerRow
    }
    
    
}

extension TestLevelPickerViewController {
    
    private func setUpLayout(){
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.height.equalTo(view.snp.height)
            $0.width.equalTo(pickerWidth)
            $0.center.equalTo(view.center)
        }
        
    }
}
