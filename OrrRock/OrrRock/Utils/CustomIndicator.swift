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

//원본 코드 출처 https://ios-development.tistory.com/682
