//
//  CustomIndicator.swift
//  OrrRock
//
//  Created by Ruyha on 2022/10/23.
//

import UIKit

import NVActivityIndicatorView
import SnapKit

class CustomIndicator {

    private static let indicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150),
                                           type: .lineSpinFadeLoader,
                                           color: .lightGray,
                                           padding: 50)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    private static let blockTouchView: UIView = {
        let view = UIView()
        return view
    }()

    static func startLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }
            blockTouchView.frame = window.frame

            window.addSubview(blockTouchView)
            blockTouchView.addSubview(indicator)
            indicator.snp.makeConstraints {
                $0.center.equalTo(blockTouchView)
            }

            indicator.startAnimating()
        }
    }

    static func stopLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            indicator.stopAnimating()
            blockTouchView.removeFromSuperview()
        }
    }
}

/*  MARK: 사용법
    인디케이터를 여러곳에서 반복적으로 사용할 것 같아 따로 뺴놓았습니다.
    사용법은 다음과 같습니다.
    
    인디게이터를 시작하려 할 때
    CustomIndicator.startLoading()
 
    인디게이터를 끝낼 때
    CustomIndicator.stopLoading()
 
    주의 사항
    1. 인디게이터가 활성화 된 상태에서는 투명한 view가 생성되어 사용자의 다른 터치 이벤트가 제한 됩니다.
    2. 키보드가 활성화 되어 있는 상태에서는 키보드 입력은 여전히 가능하기에 키보드는 숨겨 주셔야 합니다.
 
    예시는 SetGymViewController 에서 확인 가능합니다.
 */

//원본 코드 출처 https://ios-development.tistory.com/682
