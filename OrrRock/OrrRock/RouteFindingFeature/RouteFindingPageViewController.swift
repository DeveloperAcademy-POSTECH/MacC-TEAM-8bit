//
//  RouteFindingPageView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/25.
//

import UIKit
import SnapKit

protocol IsDeletingPointButtonDelegate {
    
    func hidePageNumberingLabelView()
    func showPageNumberingLabelView()
}

final class RouteFindingPageViewController: UIViewController {
    
    var delegate: IsDeletingPointButtonDelegate?
    
    var routeDataDraft: RouteDataDraft
    var pageRowOrder: Int
    var backgroundImage: UIImage
    
    var isHandButtonMode: Bool = true
    var buttonList: [RouteFindingFeatureButton] = []
    
    var beginningPosition: CGPoint = .zero
    var initialMovableViewPosition: CGPoint = .zero
    let trashView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "delete")?.resized(to: CGSize(width: 85, height: 85))
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        imageView.isHidden = true
        
        return imageView
    }()
    
    init(routeDataDraft: RouteDataDraft, pageRowOrder: Int, backgroundImage: UIImage) {
        self.routeDataDraft = routeDataDraft
        self.pageRowOrder = pageRowOrder
        self.backgroundImage = backgroundImage
        
        super.init(nibName: nil, bundle: nil)
        
        setUpBackgroundImage()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeRoutePoint(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        guard let page = routeDataDraft.routeInfoForUI.pages.first(where: { $0.rowOrder == pageRowOrder }) else { return }
        
        for pointInfo in page.points {
            
            let button = pointInfo.footOrHand == .hand ? RouteFindingFeatureHandButton() : RouteFindingFeatureFootButton()
            
            self.view.addSubview(button)
            buttonList.append(button)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRoutePointButton(_:)))
            
            button.addGestureRecognizer(panGesture)
            
            button.snp.makeConstraints{
                $0.centerX.equalTo(pointInfo.position.x)
                $0.centerY.equalTo(pointInfo.position.y)
            }
        }
        setUpLayout()
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
        
        guard sender.state == .began || sender.state == .changed || sender.state == .ended,
              let buttonView = sender.view as? RouteFindingFeatureButton
        else { return }
        
        if sender.state == .began {
            beginningPosition = sender.location(in: buttonView)
            initialMovableViewPosition = buttonView.frame.origin
        } else if sender.state == .ended {
            trashView.isHidden = true
            delegate?.showPageNumberingLabelView()
            // buttonView가 trashView영역에 들어왔을 때 point 삭제
            if buttonView.frame.intersects(trashView.frame) {
                guard let id = buttonList.firstIndex(where: { $0.id == buttonView.id }),
                      let pageNo = routeDataDraft.routeInfoForUI.pages.firstIndex(where: { $0.rowOrder == pageRowOrder }) else { return }
                
                routeDataDraft.removePointData(pageAt: pageNo, pointIndexOf: id)
                buttonList.remove(at: id)
                buttonView.removeFromSuperview()
                initialMovableViewPosition = .zero
            }
            
        } else if sender.state == .changed {
            trashView.isHidden = false
            delegate?.hidePageNumberingLabelView()
            
            trashView.image = UIImage(named:
                                        buttonView.frame.intersects(trashView.frame) ?
                                      "delete_destructive" : "delete")?.resized(to: CGSize(width: 80, height: 80))
            
            let locationInView = sender.location(in: buttonView)
            buttonView.frame.origin = CGPoint(x: buttonView.frame.origin.x + locationInView.x - beginningPosition.x,
                                              y: buttonView.frame.origin.y + locationInView.y - beginningPosition.y)
            
            // panGeture로 새로 업데이트한 좌표를 업데이트
            let translation = sender.translation(in: buttonView.superview)
            buttonView.center = CGPoint(x: buttonView.center.x + translation.x, y: buttonView.center.y + translation.y)
            sender.setTranslation(.zero, in: buttonView.superview)
            
            // point 추가
            if let button = sender.view as? RouteFindingFeatureButton,
               let index = buttonList.firstIndex(where: { $0.id == button.id }) {
                button.snp.updateConstraints {
                    $0.centerX.equalTo(sender.location(in: self.view).x)
                    $0.centerY.equalTo(sender.location(in: self.view).y)
                }
                
                let originPointInfo = routeDataDraft.routeInfoForUI.pages.first(where: { $0.rowOrder == pageRowOrder })!.points[index]
                
                routeDataDraft.updatePointData(pageAt: routeDataDraft.routeInfoForUI.pages.firstIndex(where: { $0.rowOrder == self.pageRowOrder })!,
                                               pointIndexOf: index,
                                               updateTargetPointInfo: PointInfo(id: button.id, footOrHand: originPointInfo.footOrHand,
                                                                                isForce: originPointInfo.isForce,
                                                                                position: buttonView.center,
                                                                                forceDirection: originPointInfo.forceDirection))
            }
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
    
    private func setUpLayout(){
        self.view.addSubview(trashView)
        trashView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(OrrPd.pd24.rawValue)
        }
    }
}

extension RouteFindingPageViewController: UIGestureRecognizerDelegate {
    
    func addRoutePointButton(to location: CGPoint) {
        
        var button = isHandButtonMode ? RouteFindingFeatureHandButton() : RouteFindingFeatureFootButton()
        
        self.view.addSubview(button)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRoutePointButton(_:)))
        panGesture.delegate = self
        
        button.addGestureRecognizer(panGesture)
        
        routeDataDraft.addPointData(pageAt: routeDataDraft.routeInfoForUI.pages.firstIndex(where: { $0.rowOrder == pageRowOrder })!,
                                    addTargetPointInfo: PointInfo(id: UUID(),
                                                                  footOrHand: isHandButtonMode ? .hand : .foot,
                                                                  isForce: false,
                                                                  position: location,
                                                                  forceDirection: .pi0))
        buttonList.append(button)
        
        button.snp.makeConstraints{
            $0.centerX.equalTo(location.x)
            $0.centerY.equalTo(location.y)
        }
    }
}
