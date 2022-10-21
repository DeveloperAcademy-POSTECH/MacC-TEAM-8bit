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
// 색상 확정나면 지정해주기

import SnapKit
import UIKit

final class HomeViewController : UIViewController {
    
    // MARK: UI Components
    // CollectionView의 좌우 여백을 이용해 동적으로 UI 그리기 위한 변수
    let HorizontalPaddingSize: CGFloat = 16
    var isCardView: Bool = false {
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private lazy var headerView: UIView = {
        let view = UIView()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints {
            $0.edges.equalTo(view.snp.edges)
        }
        
        return view
    }()
    
    private lazy var logoView: UILabel = {
        // 앱 로고와 타이틀 디자인이 확정나면 이 컴포넌트를 활용해 그려주기
        let view = UILabel()
        view.text = "오르락 로고"
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    private lazy var quickActionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.stack"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private lazy var toolbarView: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .systemGray5
        
        var items: [UIBarButtonItem] = []
        
        let myPageButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle"), style: .plain, target: self, action: nil)
        let addVideoButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: self, action: nil)
        
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
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        
        // CollectionView에서 사용할 Cell 등록
        view.register(HomeCollectionViewCardCell.classForCoder(),
                      forCellWithReuseIdentifier: HomeCollectionViewCardCell.identifier)
        view.register(HomeCollectionViewListCell.classForCoder(),
                      forCellWithReuseIdentifier: HomeCollectionViewListCell.identifier)
        view.register(HomeCollectionViewHeaderCell.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: HomeCollectionViewHeaderCell.identifier)
        view.register(HomeCollectionViewFooterCell.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier: HomeCollectionViewFooterCell.identifier)
        
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    // MARK: Components
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy년 M월 d일"
        return df
    }()

    // MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray5
        
        setUpLayout()
        setUICollectionViewDelegate()
    }
    
    // MARK: Layout Function
    private func setUpLayout() {
        self.view.addSubview(toolbarView)
        toolbarView.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(toolbarView.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(HorizontalPaddingSize)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(HorizontalPaddingSize)
        }
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        headerView.addSubview(logoView)
        logoView.snp.makeConstraints {
            $0.bottom.equalTo(headerView.snp.bottom).inset(16)
            $0.leading.equalTo(headerView.snp.leading).offset(24)
        }
        
        headerView.addSubview(quickActionButton)
        quickActionButton.snp.makeConstraints {
            $0.bottom.equalTo(headerView.snp.bottom).inset(16)
            $0.trailing.equalTo(headerView.snp.trailing).inset(24)
        }
    }
    
    private func setUICollectionViewDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
