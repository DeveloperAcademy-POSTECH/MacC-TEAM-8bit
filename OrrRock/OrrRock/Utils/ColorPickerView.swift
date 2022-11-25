//
//  ColorPickerView.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/23.
//

import UIKit
import SnapKit

protocol ColorPickerViewDelegate {
    func didColorChanged(selectedColorValue: Int)
}

class ColorPickerView: UIView{
    //피커뷰의 고정적으로 쓰이는 넓이
    private var pickerWidth = 45
    //피커뷰가 시작 될때 선택 되어 있어야 하는 값
    var pickerSelectValue = 0
    //초기선택된 레이블을 설정에 사용되는 값
    var isFirstLoad : Bool?
    
    //피커뷰에 들어갈 리스트들
    private let colorValues: [UIColor?] = [.holder0, .holder1, .holder2, .holder3, .holder4, .holder5, .holder6, .holder7, .holder8, .holder9]
    //회전각도
    private var rotationAngle: CGFloat! = -90  * (.pi/180)
        
    private var changedLevelPicker = false
    
    var delegate: ColorPickerViewDelegate?
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        return picker
    }()
    
    
    lazy var pickerSetLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPicker()
        pickerView.subviews[1].isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setPicker() {
        setUpLayout()
        self.pickerView.delegate?.pickerView?(self.pickerView, didSelectRow: pickerSelectValue, inComponent: 0)
    }
    
    override func layoutSubviews() {
        guard changedLevelPicker else {
            pickerSelectValue =  pickerSelectValue < 0 ? 0 : pickerSelectValue
            pickerSelectValue =  pickerSelectValue > colorValues.count ? colorValues.count - 1: pickerSelectValue
            self.pickerView.selectRow(pickerSelectValue, inComponent: 0, animated: true)
            changedLevelPicker = true
            return
        }
    }
    
}
extension ColorPickerView : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(pickerWidth)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorValues.count
    }
    
    //MARK: 여기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didColorChanged(selectedColorValue: row)
        guard let selectView = pickerView.view(forRow: row, forComponent: component) else {
            isFirstLoad = false
            return
        }

        let selectLabel = selectView.subviews[0] as! UILabel
        selectLabel.backgroundColor = .orrWhite
        selectLabel.layer.shadowColor = UIColor.orrBlack?.cgColor
        selectLabel.layer.shadowOpacity = 1.0
        selectLabel.layer.shadowOffset = CGSize.zero
        selectLabel.layer.shadowRadius = 10


        if let beforeView = pickerView.view(forRow: row - 1, forComponent: component) {
            let beforeLabel = beforeView.subviews[0] as! UILabel
            beforeLabel.backgroundColor = .clear
        }
        
        if let afterView = pickerView.view(forRow: row + 1, forComponent: component) {
            let afterLabel = afterView.subviews[0] as! UILabel
            afterLabel.backgroundColor = .clear
        }
        
        guard let myBool = isFirstLoad else{
            isFirstLoad = false
            return
        }
        
        if !myBool{
            isFirstLoad = true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerRow = UIView()
        pickerRow.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: pickerWidth)
        
        lazy var backLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = CGFloat((pickerWidth)/2)
            label.backgroundColor = .clear
            label.layer.masksToBounds = true
            return label
        }()
        
        lazy var rowLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = CGFloat((pickerWidth - 10)/2)
            label.layer.masksToBounds = true
            return label
        }()
        
        pickerRow.addSubview(backLabel)
        backLabel.snp.makeConstraints {
            $0.leading.equalTo(pickerRow.snp.leading)
            $0.trailing.equalTo(pickerRow.snp.trailing)
            $0.top.equalTo(pickerRow.snp.top)
            $0.bottom.equalTo(pickerRow.snp.bottom)
        }
        
        backLabel.addSubview(rowLabel)
        rowLabel.snp.makeConstraints {
            $0.leading.equalTo(backLabel.snp.leading).offset(5)
            $0.trailing.equalTo(backLabel.snp.trailing).offset(-5)
            $0.top.equalTo(backLabel.snp.top).offset(5)
            $0.bottom.equalTo(backLabel.snp.bottom).offset(-5)
        }
        
        rowLabel.backgroundColor = colorValues[row]
        pickerRow.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        guard let myBool = isFirstLoad else{
            return pickerRow
        }
        guard !myBool else{
            return pickerRow
        }
        guard let selectView = pickerView.view(forRow: pickerSelectValue, forComponent: component) else {
            return pickerRow
        }
        
        let selectLabel = selectView.subviews[0] as! UILabel
        selectLabel.backgroundColor = .white
        return pickerRow
    }
    
}
extension ColorPickerView {
    
    private func setUpLayout(){
        self.addSubview(pickerSetLabel)
        pickerSetLabel.snp.makeConstraints {
            $0.height.equalTo(pickerWidth) // width
            $0.width.equalTo(self.snp.width) //
            $0.center.equalToSuperview()
        }
        
        self.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.height.equalTo(pickerSetLabel.snp.width) // width
            $0.width.equalTo(pickerSetLabel.snp.height) // height
            $0.centerX.equalTo(pickerSetLabel.snp.centerX)
            $0.centerY.equalTo(pickerSetLabel.snp.centerY)
        }
    }
}
