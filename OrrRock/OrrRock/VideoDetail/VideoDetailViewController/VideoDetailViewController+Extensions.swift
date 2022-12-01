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
                    videoDetailPageViewController.isPagingEnabled = false
                }
            case UISwipeGestureRecognizer.Direction.down :
                if !isShowInfo{
                    navigationController?.isNavigationBarHidden = false
                    navigationController?.isToolbarHidden = true
                    navigationController?.hidesBarsOnTap = false
                    self.navigationController?.popViewController(animated: true)
                }else{
                    if !isShowKeyboard{
                        showInfo()
                        videoDetailPageViewController.isPagingEnabled = true
                    }
                }
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
        if isShowKeyboard{
            feedbackText = videoInfoView.feedbackTextView.text!
            DataManager.shared.updateFeedback(videoInformation: currentVideoInformation!, feedback: feedbackText!)
            self.view.endEditing(true)
        }
    }
}
