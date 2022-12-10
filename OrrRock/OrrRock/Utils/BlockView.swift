//
//  BlockView.swift
//  OrrRock
//
//  Created by Ruyha on 2022/12/09.
//

import UIKit
import SnapKit

class BlockView {
    
    private static let blockTouchView: UIView = {
        let view = UIView()
        return view
    }()
    
    static func startBlock() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }
            blockTouchView.frame = window.frame
            window.addSubview(blockTouchView)
        }
    }
    
    static func stopBlock() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            blockTouchView.removeFromSuperview()
        }
    }
}

/* MARK: 사용법
    일시적으로 사용자의 제스쳐를 방어할때 사용함 ex 연타 상황
    BlockView.startBlock() => 모든 제스쳐 차단
    BlockView.stopBlock() => 차단 해제
 */
