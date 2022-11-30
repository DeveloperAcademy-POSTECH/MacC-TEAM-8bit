//
//  Color+.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/20.
//  공통적으로 사용하는 컬러값에 대한 extension입니다.

import UIKit

extension UIColor {
    //MAIN COLOR
    static let orrUPBlue = UIColor(named: "oRUPBlue")
    
    //Black & White
    static let orrBlack = UIColor(named: "oRBlack")
    static let orrWhite = UIColor(named: "oRWhite")
    
    //GRAY COLOR
    static let orrGray100 = UIColor(named: "oRGray100")
    static let orrGray050 = UIColor(named: "oRGray050")
    static let orrGray200 = UIColor(named: "oRGray200")
    static let orrGray300 = UIColor(named: "oRGray300")
    static let orrGray400 = UIColor(named: "oRGray400")
    static let orrGray500 = UIColor(named: "oRGray500")
    static let orrGray600 = UIColor(named: "oRGray600")
    static let orrGray700 = UIColor(named: "oRGray700")
    static let orrGray800 = UIColor(named: "oRGray800")
    static let orrGray900 = UIColor(named: "oRGray900")
    static let orrGray950 = UIColor(named: "oRGray950")


    //SUB COLOR
    static let orrPass = UIColor(named: "oRPass")
    static let orrFail = UIColor(named: "oRFail")
    
    //Holder Picker Color
    static let holder0 = UIColor(named: "V0_Color")
    static let holder1 = UIColor(named: "V1_Color")
    static let holder2 = UIColor(named: "V2_Color")
    static let holder3 = UIColor(named: "V3_Color")
    static let holder4 = UIColor(named: "V4_Color")
    static let holder5 = UIColor(named: "V5_Color")
    static let holder6 = UIColor(named: "V6_Color")
    static let holder7 = UIColor(named: "V7_Color")
    static let holder8 = UIColor(named: "V8_Color")
    static let holder9 = UIColor(named: "V9_Color")
    
    //MARK: 사용시 디자인 가이드 꼭 확인 바람 다크,라이트모드 둘다 확인해야함
    //Custom Color
    static let orrWhiteCustom = UIColor(named: "oRWhiteCustom")
    static let orrGray050Custom = UIColor(named: "oRGray050Custom")
}

extension UIColor {
    convenience init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
  }
}

extension UIColor {
          func colorImage(size: CGSize? = nil) -> UIImage? {
            let rect = CGRect(x: 0, y: 0, width: size?.width ?? 1, height: size?.height ?? 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(self.cgColor)
            context?.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    
}
