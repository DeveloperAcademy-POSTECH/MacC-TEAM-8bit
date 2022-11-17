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
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeUp)
        
    }
    
    func addTapGestureToVideoPlayView(){
        videoPlayView.addGestureRecognizer(tapGesture)
    }
    
    func removeTapGestureFromVideoPlayView(){
        videoPlayView.removeGestureRecognizer(tapGesture)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up :
                if !isShowInfo{
                    showInfo()
                }
            case UISwipeGestureRecognizer.Direction.down :
                if !isShowInfo{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    showInfo()
                }
            case UISwipeGestureRecognizer.Direction.left :
                print("left")
            case UISwipeGestureRecognizer.Direction.right :
                print("right")
            default:
                break
            }
        }
    }
    
    @objc func respondToTapGesture(_ gesture: UITapGestureRecognizer){
        showInfo()
    }
}
