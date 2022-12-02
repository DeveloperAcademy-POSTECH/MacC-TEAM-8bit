//
//  RouteFindingThirdOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingThirdOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables

    var isMovingToNextPage: Bool = false
    
    // MARK: View Components
    
    override var descriptionView: UILabel {
        get { return super.descriptionView }
        set { self.descriptionView = newValue }
    }
    
    var gestureVC: RouteFindingOnboardingPanViewController = {
       let vc = RouteFindingOnboardingPanViewController()
        
        return vc
    }()
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gestureVC.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionView.text = "추가된 동작을 꾸욱 눌러\n이동 및 삭제할 수 있어요"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Functions
    
    // MARK: @objc Functions
}


extension RouteFindingThirdOnboardingViewController {
    
    // MARK: Set Up Functions

    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(gestureVC.view)
        gestureVC.view.snp.makeConstraints {
            $0.edges.equalTo(super.backgroundImageView)
        }
        
        super.setUpSkipButtonLayout()
    }
}

extension RouteFindingThirdOnboardingViewController: RouteFindingOnboardingPanViewControllerDelegate {
    func buttonRemoved() {
        if !isMovingToNextPage {
            isMovingToNextPage = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.triggerMoveToNextPage()
            }
        }
    }
}

protocol RouteFindingOnboardingPanViewControllerDelegate {
    func buttonRemoved()
}

final class RouteFindingOnboardingPanViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var delegate: RouteFindingOnboardingPanViewControllerDelegate?
    var isHandButton: Bool = true
    
    
    var beginningPosition: CGPoint = .zero
    var initialMovableViewPosition: CGPoint = .zero
    
    let trashView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "delete")?.resized(to: CGSize(width: 85, height: 85))
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        imageView.isHidden = true
        
        return imageView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        addRoutePointButton(to: view.center)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addRoutePointButton(to location: CGPoint) {
        var button = RouteFindingFeatureHandButton()
        self.view.addSubview(button)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRoutePointButton(_:)))
        panGesture.delegate = self
        
        button.addGestureRecognizer(panGesture)
        
        button.snp.makeConstraints{
            $0.centerX.equalTo(location.x)
            $0.centerY.equalTo(location.y)
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
            // buttonView가 trashView영역에 들어왔을 때 point 삭제
            if buttonView.frame.intersects(trashView.frame) {
//                trashView.image = UIImage(named: "delete_destructive")?.resized(to: CGSize(width: 85, height: 85))
                buttonView.removeFromSuperview()
                initialMovableViewPosition = .zero
                
                delegate?.buttonRemoved()
            }
            
        } else if sender.state == .changed {
            trashView.isHidden = false
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
            buttonView.snp.updateConstraints {
                $0.centerX.equalTo(sender.location(in: self.view).x)
                $0.centerY.equalTo(sender.location(in: self.view).y)
            }
        }
    }
    
    func setUpLayout() {
        view.addSubview(trashView)
        trashView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-120)
            $0.width.height.equalTo(56)
        }
    }
}
