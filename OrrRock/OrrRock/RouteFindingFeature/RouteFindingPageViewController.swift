//
//  RouteFindingPageView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/25.
//

import UIKit

final class RouteFindingPageViewController: UIViewController {
    var pageInfo: PageInfo
    
    var isHandButton: Bool = true
    var buttonList: [RouteFindingFeatureButton] = []
    
    init(pageInfo: PageInfo) {
        self.pageInfo = pageInfo
        if self.pageInfo.points == nil {
            self.pageInfo.points = []
        }
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemMint
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeRoutePoint(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func makeRoutePoint(_ sender: UITapGestureRecognizer){
        
        if sender.state == .ended {
            if sender.location(in: self.view).y < self.view.frame.maxY {
                addRoutePointButton(to: sender.location(in: self.view))
                print("\(sender.location(in: self.view))")
            }
        }
    }
    
    @objc
    func moveRoutePointButton(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed,
              let box = sender.view
        else { return }
        
        let translation = sender.translation(in: box.superview)
        box.center = CGPoint(x: box.center.x + translation.x, y: box.center.y + translation.y)
        sender.setTranslation(.zero, in: box.superview)
        
        if let button = sender.view as? RouteFindingFeatureButton,
           let index = buttonList.firstIndex { $0.id == button.id } {
               self.pageInfo.points![index].position = sender.location(in: self.view)
               
               button.snp.updateConstraints {
                   $0.centerX.equalTo(sender.location(in: self.view).x)
                   $0.centerY.equalTo(sender.location(in: self.view).y)
               }
           }
    }
    
    func addRoutePointButton(to location: CGPoint ) {
        
        var button = isHandButton ? RouteFindingFeatureHandButton() : RouteFindingFeatureFootButton()
        
        self.view.addSubview(button)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRoutePointButton(_:)))
        button.addGestureRecognizer(panGesture)
        // pageView에 points 좌표를 넘겨줌
        
        pageInfo.points?.append(PointInfo(footOrHand: .hand, isForce: false, position: location, forceDirection: .pi0))
        buttonList.append(button)
        
        button.snp.makeConstraints{
            $0.centerX.equalTo(location.x)
            $0.centerY.equalTo(location.y)
        }
    }
}
