//
//  RouteFindingFeatureViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/25.
//

import UIKit

import SnapKit

class RouteFindingFeatureViewController: UIViewController {

    // MARK: Variables
    var routeInfo: RouteInfo
    var pages: [PageInfo]
    var pageViews: [RouteFindingPageView] = []
    
    var beforeCell: RouteFindingThumbnailCollectionViewCell?
    var centerCell: RouteFindingThumbnailCollectionViewCell?
    var afterCell: RouteFindingThumbnailCollectionViewCell?
    
    // MARK: View Components
    var backgroundImageView: UIImageView = {
        let view = UIImageView()
//        view.image = 루트파인딩 문제 이미지 삽입
        view.backgroundColor = .white
        return view
    }()
    
    var pageView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let thumbnailCollectionView: UICollectionView = {
        let layout = RouteFindingThumbnailCollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(RouteFindingThumbnailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: RouteFindingThumbnailCollectionViewCell.identifier)
        collection.register(RouteFindingThumbnailCollectionViewAddCell.classForCoder(), forCellWithReuseIdentifier: RouteFindingThumbnailCollectionViewAddCell.identifier)
        
        return collection
    }()
    
    // MARK: Life Cycle Functions
    init(routeInfo: RouteInfo) {
        self.routeInfo = routeInfo
        self.pages = routeInfo.pages
        
        super.init(nibName: nil, bundle: nil)
        
        var views: [RouteFindingPageView] = []
        routeInfo.pages.forEach { pageInfo in
            let view = convertPageInfoToPageView(from: pageInfo)
//            view.backgroundColor = .systemRed
            
            self.backgroundImageView.addSubview(view)
            views.append(view)
        }
        self.pageViews = views
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpLayout()
        setUpThumbnailCollectionDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // CollectionView가 다 그려지고 난 뒤, CollectionView의 content에 Inset을 넣어 끝까지 스크롤이 가능하도록 하기
        let layoutMargins: CGFloat = self.thumbnailCollectionView.layoutMargins.left
        let sideInset = self.view.frame.width / 2 - layoutMargins
        self.thumbnailCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    // MARK: Functions
    func convertPageInfoToPageView(from pageInfo: PageInfo) -> RouteFindingPageView {
        let view = RouteFindingPageView()
        
        return view
    }
    
    func selectPage() {
        guard let selectedCell = centerCell else { return }
        pageView.snp.removeConstraints()
        
        pageView = pageViews[selectedCell.indexPathOfCell.row]
        pageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: @objc Functions
    
}

extension RouteFindingFeatureViewController {
    // MARK: SetUp Functions
    func setUpLayout() {
        // 화면 비율 기기 대응 작업
        view.addSubview(backgroundImageView)
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.windows.first
        let contentHeight = view.frame.height - Double(((window?.safeAreaInsets.top)! + (window?.safeAreaInsets.bottom)!))
        let contentWidth = view.frame.width
        let widthFirst: Bool = contentWidth < (contentHeight - 69) * 9 / 16
        backgroundImageView.snp.makeConstraints {
            if widthFirst {
                $0.width.equalTo(contentWidth)
                $0.height.equalTo(contentWidth * 16 / 9)
            } else {
                $0.height.equalTo(contentHeight - 69)
                $0.width.equalTo((contentHeight - 69) * 9 / 16)
            }
            $0.top.equalTo(view.forLastBaselineLayout.snp_topMargin)
            $0.centerX.equalToSuperview()
        }
                
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            $0.height.equalTo(74)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setUpThumbnailCollectionDelegate() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
}

extension RouteFindingFeatureViewController: RouteFindingThumbnailCollectionViewAddCellDelegate {
    func tapAddPageButton() {
        pages.append(PageInfo(rowOrder: 5))
        let newView = RouteFindingPageView()
        self.backgroundImageView.addSubview(newView)
        pageViews.append(newView)
        
        thumbnailCollectionView.reloadData()
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: pageViews.count, section: 0), at: .centeredHorizontally, animated: true)
    }
}
