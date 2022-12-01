//
//  RouteFindingThirdOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingThirdOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables

    
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
    }
}

extension RouteFindingThirdOnboardingViewController: RouteFindingOnboardingPanViewControllerDelegate {
    func buttonRemoved() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.triggerMoveToNextPage()
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
        // TODO: 드래그할 때만 trahView가 보일 수 있도록 true로 초기화
        imageView.isHidden = false
        
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
        
        guard sender.state == .began || sender.state == .changed,
              let buttonView = sender.view as? RouteFindingFeatureButton
        else { return }
        
        if sender.state == .began {
            beginningPosition = sender.location(in: buttonView)
            initialMovableViewPosition = buttonView.frame.origin
        } else if sender.state == .changed {
            buttonView.isHidden = false
            let locationInView = sender.location(in: buttonView)
            buttonView.frame.origin = CGPoint(x: buttonView.frame.origin.x + locationInView.x - beginningPosition.x, y: buttonView.frame.origin.y + locationInView.y - beginningPosition.y)
            
            // buttonView가 trashView영역에 들어왔을 때 point 삭제
            if buttonView.frame.intersects(trashView.frame) && !trashView.isHidden {
                
                initialMovableViewPosition = .zero
                buttonView.removeFromSuperview()
                delegate?.buttonRemoved()
                return
            }
            
            // panGeture로 새로 업데이트한 좌표를 업데이트
            let translation = sender.translation(in: buttonView.superview)
            buttonView.center = CGPoint(x: buttonView.center.x + translation.x, y: buttonView.center.y + translation.y)
            sender.setTranslation(.zero, in: buttonView.superview)
            
            // point 추가
            if let button = sender.view as? RouteFindingFeatureButton {
                button.snp.updateConstraints {
                    $0.centerX.equalTo(sender.location(in: self.view).x)
                    $0.centerY.equalTo(sender.location(in: self.view).y)
                }
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
