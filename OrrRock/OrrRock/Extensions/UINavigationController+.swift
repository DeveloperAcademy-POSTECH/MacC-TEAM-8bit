//
//  UINavigationController+.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/27.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}



/*
 네이게이션바 아이템을 추가했을때 뒤로가기 제스쳐가 동작하지 않는 문제를 해결해줍니다.
 UIBarButtonItem
 
 해당코드의 기능을 보고 싶다면 전체 코드를 주석처리한 상태에서
 저장된 비디오 -> 더보기 를 클릭후 뒤로 가기 제츠처를 비교해 주시면됩니다.
 
 코드출처 및 자세한 설명은 하단의 링크를 확인해주세요.
 https://stackoverflow.com/questions/34942571/how-to-enable-back-left-swipe-gesture-in-uinavigationcontroller-after-setting-le
 */
