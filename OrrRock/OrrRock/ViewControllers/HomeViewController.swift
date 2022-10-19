//
//  HomeCollectionViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// QuickAction 동작 구현
// Toolbar의 myPageButton의 action으로 마이페이지로 이동하는 동작 구현
// Toolbar의 addVideoButton의 action으로 영상 추가로 이동하는 동작 구현
// toolbar button 색상 확정나면 지정해주기

import Foundation
import SnapKit
import UIKit

class HomeViewController : UIViewController {
    
    // MARK: UI Components
    // CollectionView의 좌우 여백을 이용해 동적으로 UI 그리기 위한 변수
    let HorizontalPaddingSize: CGFloat = 16
    
    let headerView: UIView = {
        let view = UIView()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        
        return view
    }()
    
    let logoView: UILabel = {
        // 앱 로고와 타이틀 디자인이 확정나면 이 컴포넌트를 활용해 그려주기
        let view = UILabel()
        view.text = "오르락 로고"
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    let quickActionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.stack"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    let toolbarView: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .systemGray5

        var items: [UIBarButtonItem] = []
        
        let myPageButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle"), style: .plain, target: HomeViewController.self, action: nil)
        let addVideoButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: HomeViewController.self, action: nil)
        
        // toolbar 내 Spacer() 역할
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: HomeViewController.self, action: nil)
        
        items.append(myPageButton)
        items.append(flexibleSpace)
        items.append(addVideoButton)

        items.forEach { (item) in
            item.tintColor = .systemBlue
        }

        view.setItems(items, animated: true)
        
        return view
    }()
    
    let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        view.register(HomeCollectionViewCardCell.classForCoder(),
                      forCellWithReuseIdentifier: "homeCollectionViewCardCell")
        view.register(HomeCollectionViewHeaderCell.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: HomeCollectionViewHeaderCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    // MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray5
        
        setLayout()
        setUICollectionView()
    }
    
    // MARK: Layout Function
    func setLayout() {
        self.view.addSubview(toolbarView)
        toolbarView.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(toolbarView.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(HorizontalPaddingSize)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(HorizontalPaddingSize)
        }
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        headerView.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.bottom.equalTo(headerView.snp.bottom).inset(16)
            make.leading.equalTo(headerView.snp.leading).offset(24)
        }
        
        headerView.addSubview(quickActionButton)
        quickActionButton.snp.makeConstraints { make in
            make.bottom.equalTo(headerView.snp.bottom).inset(16)
            make.trailing.equalTo(headerView.snp.trailing).offset(-24)
        }
    }
    
    func setUICollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

