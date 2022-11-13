//
//  CustomButton.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/08.
//

import UIKit

// 버튼 클릭을 했을 때 딸깍하는 효과를 위한 UIButton 클래스
class CustomButton: UIButton {
	
	var isActivated: Bool = false {
		didSet {
			animate()
		}
	}
	
	func animate(){
		UIView.animate(withDuration: 0.1, animations: { [weak self] in
			guard let self = self else { return }
			
			//1. 클릭 되었을때 작아지기 - 스케일 즉 크기 변경 -> 50퍼센트로 1초동안
			self.transform = self.transform.scaledBy(x: 0.7, y: 0.7)
		}, completion: { _ in
			//2. 원래 크기로 돌리기 1초동안
			UIView.animate(withDuration: 0.1, animations: {
				self.transform = CGAffineTransform.identity
			})
		})
	}
}
