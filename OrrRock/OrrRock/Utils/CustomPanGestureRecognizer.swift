//
//  CustomPanGestureRecognizer.swift
//  OrrRock
//
//  Created by Yeni Hwang on 2022/12/01.
//

import UIKit

protocol CustomPanGestureRecognizerDelegate {
    func hideTrashView()
}

class CustomPanGestureRecognizer: UIPanGestureRecognizer {
    
    var panGestureDelegate: CustomPanGestureRecognizerDelegate?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        panGestureDelegate?.hideTrashView()
    }
}

