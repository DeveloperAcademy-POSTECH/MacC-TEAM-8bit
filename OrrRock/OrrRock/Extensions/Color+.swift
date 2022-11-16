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

    //GRAY COLOR
    static let orrBlack = UIColor(named: "oRBlack")
    static let orrWhite = UIColor(named: "oRWhite")
    static let orrGray1 = UIColor(named: "oRGray1")
    static let orrGray2 = UIColor(named: "oRGray2")
    static let orrGray3 = UIColor(named: "oRGray3")
    static let orrGray4 = UIColor(named: "oRGray4")

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
