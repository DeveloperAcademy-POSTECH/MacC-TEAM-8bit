//
//  RouteFindingPageView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/25.
//

import UIKit

import SnapKit

final class RouteFindingPageViewController: UIViewController {
    var routeDataDraft: RouteDataDraft
    var pageRowOrder: Int
    var backgroundImage: UIImage
    
    //    var pageInfo: PageInfo
    var isHandButton: Bool = true
    var buttonList: [RouteFindingFeatureButton] = []
    
    
    init(routeDataDraft: RouteDataDraft, pageRowOrder: Int, backgroundImage: UIImage) {
        self.routeDataDraft = routeDataDraft
        self.pageRowOrder = pageRowOrder
        self.backgroundImage = backgroundImage
        
        super.init(nibName: nil, bundle: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeRoutePoint(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        guard let page = routeDataDraft.routeInfoForUI.pages.first(where: { $0.rowOrder == pageRowOrder }) else { return }
        
        if page.points.count > 0 {
            
            page.points.forEach { pointInfo in
                var button = isHandButton ? RouteFindingFeatureHandButton() : RouteFindingFeatureFootButton()
                
                self.view.addSubview(button)
                buttonList.append(button)
                
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRoutePointButton(_:)))
                
                button.addGestureRecognizer(panGesture)
                
                button.snp.makeConstraints{
                    $0.centerX.equalTo(pointInfo.position.x)
                    $0.centerY.equalTo(pointInfo.position.y)
                }
            }
        }
        
        setUpBackgroundImage()
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
           let index = buttonList.firstIndex(where: { $0.id == button.id }) {
               
               
//               let originPointInfo = routeDataDraft.routeInfoForUI.pages[routeDataDraft.routeInfoForUI.pages.first(where: { $0.rowOrder == self.pageRowOrder })]
               let originPointInfo = routeDataDraft.routeInfoForUI.pages.first(where: { $0.rowOrder == pageRowOrder })!.points[index]
               
               
               routeDataDraft.updatePointData(pageAt: routeDataDraft.routeInfoForUI.pages.firstIndex(where: { $0.rowOrder == self.pageRowOrder })!,
                                              pointIndexOf: index,
                                              updateTargetPointInfo: PointInfo(id: originPointInfo.id, footOrHand: originPointInfo.footOrHand,
                                                                               isForce: originPointInfo.isForce,
                                                                               position: box.center,
                                                                               forceDirection: originPointInfo.forceDirection))
               //               self.pageInfo.points![index].position = sender.location(in: self.view)
               
               button.snp.updateConstraints {
                   $0.centerX.equalTo(sender.location(in: self.view).x)
                   $0.centerY.equalTo(sender.location(in: self.view).y)
               }
           }
    }
    
    func addRoutePointButton(to location: CGPoint) {
        
        var button = isHandButton ? RouteFindingFeatureHandButton() : RouteFindingFeatureFootButton()
        
        self.view.addSubview(button)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRoutePointButton(_:)))
        button.addGestureRecognizer(panGesture)
        // pageView에 points 좌표를 넘겨줌
        
        
//                pageInfo.points?.append(PointInfo(footOrHand: isHandButton ? .hand : .foot, isForce: false, position: location, forceDirection: .pi0))
        routeDataDraft.addPointData(pageAt: routeDataDraft.routeInfoForUI.pages.firstIndex(where: { $0.rowOrder == pageRowOrder })!,
                                    addTargetPointInfo: PointInfo(id: UUID(), footOrHand: isHandButton ? .hand : .foot, isForce: false, position: location, forceDirection: .pi0))
        buttonList.append(button)
        
        button.snp.makeConstraints{
            $0.centerX.equalTo(location.x)
            $0.centerY.equalTo(location.y)
        }
    }
    
    func setUpBackgroundImage() {
        let backgroundImage = backgroundImage
        let backgroundImageView = UIImageView(image: backgroundImage)
        
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
