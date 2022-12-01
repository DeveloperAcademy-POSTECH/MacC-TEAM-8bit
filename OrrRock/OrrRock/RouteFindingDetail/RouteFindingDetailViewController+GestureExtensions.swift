//
//  RouteFindingDetailViewController+GestureExtensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/12/01.
//

import UIKit

extension RouteFindingDetailViewController {
    func addUIGesture(){
        //다이렉션과 호출할 함수,감지할 액션를 정해 해당뷰에 더해주면 Gesture 완성!
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeUp)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(respondToTapGesture(_:)))
        view.addGestureRecognizer(tapgesture)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up :
                if !isShowingInfo && !self.navigationController!.isToolbarHidden {
                    showInfo()
                }
            case UISwipeGestureRecognizer.Direction.down :
                if !isShowingInfo {
                    navigationController?.isNavigationBarHidden = false
                    navigationController?.isToolbarHidden = true
                    navigationController?.hidesBarsOnTap = false
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                break
            }
        }
    }
}
