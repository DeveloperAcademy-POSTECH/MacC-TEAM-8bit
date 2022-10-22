//
//  String+.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/10/22.
//

import Foundation

extension String {
	//MARK: String -> Date 타입 변환 메서드
	func stringToDate() -> Date? { // "yyyy-MM-dd 00:00:00"
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy년 M월 d일"
		dateFormatter.locale = Locale(identifier:"ko_KR")
		
		if let date = dateFormatter.date(from: self) {
			return date
		} else {
			return nil
		}
	}
}
