//
//  VideoDetailViewController+Extensions.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/17.
//

import UIKit
import SnapKit

extension VideoDetailViewController{
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
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up :
                if !isShowInfo && !self.navigationController!.isToolbarHidden{
                    showInfo()
                }
            case UISwipeGestureRecognizer.Direction.down :
                if !isShowInfo{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    showInfo()
                }
            case UISwipeGestureRecognizer.Direction.left :
                print("left")
                //다음 기능을 위해 남겨놓음
            case UISwipeGestureRecognizer.Direction.right :
                print("right")
                //다음 기능을 위해 남겨놓음
            default:
                break
            }
        }
    }
    
    @objc func respondToTapGesture(_ gesture: UITapGestureRecognizer){
        if !isShowInfo{
            self.topSafeAreaView.layer.opacity = self.navigationController!.isToolbarHidden ? 1.0 : 0.0
            self.bottomSafeAreaView.layer.opacity = self.navigationController!.isToolbarHidden ? 1.0 : 0.0
            self.navigationController?.isNavigationBarHidden = self.navigationController!.isToolbarHidden ? false : true
            self.navigationController?.isToolbarHidden = self.navigationController!.isToolbarHidden ? false : true
        }
        
        
        
        
        print("touched")
    }
}
