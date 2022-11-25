//
//  ViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/24.
//

import UIKit
import SnapKit

class RouteFindingMainViewController: UIViewController {
    
    lazy var topView : UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "루트 파인딩"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    lazy var plusButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)), for: .normal)
        button.tintColor = .orrGray600
        return button
    }()
    
    lazy var segmentedControl: UnderlineSegmentedControl = {
        let control = UnderlineSegmentedControl(items: ["ALL", "도전 중","도전 성공"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    lazy var allRouteFindingViewController : UIViewController = {
        let vc = RouteFindingSectionViewController()
        return vc
    }()
    
    lazy var challengeRouteFindingViewController : UIViewController = {
        let vc = RouteFindingSectionViewController()
        return vc
    }()
    
    lazy var successRouteFindingViewController : UIViewController = {
        let vc = RouteFindingSectionViewController()
        return vc
    }()
    
    lazy var dataViewControllers: [UIViewController] = {
        return [allRouteFindingViewController,challengeRouteFindingViewController,successRouteFindingViewController]
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    var currentPage: Int = 0 {
       didSet {
         // from segmentedControl -> pageViewController 업데이트
         let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
         self.pageViewController.setViewControllers(
           [dataViewControllers[self.currentPage]],
           direction: direction,
           animated: true,
           completion: nil
         )
       }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setNavigationBar()
        setSegment()
        setUpDelegate()
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orrGray400,.font: UIFont.systemFont(ofSize: 17, weight: .bold)], for: .normal)
        self.segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.orrBlack,
                .font: UIFont.systemFont(ofSize: 17, weight: .bold)
            ],
            for: .selected
        )
        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
            self.segmentedControl.selectedSegmentIndex = 0
            self.changeValue(control: self.segmentedControl)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setSegment(){
        self.segmentedControl.selectedSegmentIndex = 0
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setUpDelegate() {
        
    }
    @objc private func changeValue(control: UISegmentedControl) {
      self.currentPage = control.selectedSegmentIndex
    }
    
    func setUpLayout(){
        view.backgroundColor = .orrGray100
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.forLastBaselineLayout.snp_topMargin).offset(OrrPd.pd8.rawValue)
            $0.width.equalToSuperview()
            $0.height.equalTo(26)
        }
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(OrrPd.pd16.rawValue)
        }
        topView.addSubview(plusButton)
        plusButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-OrrPd.pd16.rawValue)
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(OrrPd.pd16.rawValue)
            $0.height.equalTo(30)
        }
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
        
    }
    
    func setNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        
    }
    
}
