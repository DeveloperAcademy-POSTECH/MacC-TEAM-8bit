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
    static let orrGray200 = UIColor(named: "oRGray200")
    static let orrGray300 = UIColor(named: "oRGray300")
    static let orrGray400 = UIColor(named: "oRGray400")
    static let orrGray500 = UIColor(named: "oRGray500")
    static let orrGray600 = UIColor(named: "oRGray600")
    static let orrGray700 = UIColor(named: "oRGray700")
    static let orrGray800 = UIColor(named: "oRGray800")
    static let orrGray900 = UIColor(named: "oRGray900")

    //SUB COLOR
    static let orrPass = UIColor(named: "oRPass")
    static let orrFail = UIColor(named: "oRFail")
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
