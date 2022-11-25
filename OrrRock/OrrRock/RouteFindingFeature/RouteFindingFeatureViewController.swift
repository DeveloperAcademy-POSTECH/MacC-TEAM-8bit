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
    
    lazy var deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelDeleteMode))
        view.addGestureRecognizer(gestureRecognizer)
        
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(deletePage(_:)), for: .touchUpInside)
        button.tintColor = .systemRed
        
        return button
    }()
    
    lazy var deleteImage: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 62, height: 62))
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: Life Cycle Functions
    init(routeInfo: RouteInfo) {
        self.routeInfo = routeInfo
        self.pages = routeInfo.pages
        
        super.init(nibName: nil, bundle: nil)
        
        var views: [RouteFindingPageView] = []
        routeInfo.pages.forEach { pageInfo in
            let view = convertPageInfoToPageView(from: pageInfo)
            
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
    
    func showDeleteView(for indexPath: IndexPath) {
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerX.equalTo(deleteView.snp.centerX)
            $0.bottom.equalTo(thumbnailCollectionView.snp.top).offset(-20)
        }
        
        deleteView.addSubview(deleteImage)
        deleteImage.snp.makeConstraints {
            $0.center.equalTo(self.thumbnailCollectionView.cellForItem(at: indexPath)!.snp.center)
            $0.width.height.equalTo(self.thumbnailCollectionView.cellForItem(at: indexPath)!.frame.width)
        }
    }
    
    // MARK: @objc Functions
    @objc func cancelDeleteMode() {
        deleteView.removeFromSuperview()
        deleteButton.removeFromSuperview()
        deleteImage.removeFromSuperview()
        deleteImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @objc func deletePage(_ sender: UIButton) {
        guard let targetPageCell = centerCell else { return }
        
        if pages.count > 1 {
            pages.remove(at: targetPageCell.indexPathOfCell.row)
            pageViews.remove(at: targetPageCell.indexPathOfCell.row)
        }
        
        thumbnailCollectionView.reloadData()
        
        let nextPath = IndexPath(row: (targetPageCell.indexPathOfCell.row - 1 >= 0) ? targetPageCell.indexPathOfCell.row - 1 : 1,
                                 section: targetPageCell.indexPathOfCell.section)
        
        thumbnailCollectionView.scrollToItem(at: nextPath, at: .centeredHorizontally, animated: true)
//        scrollViewDidScroll(collectionView)
        cancelDeleteMode()
    }
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

extension RouteFindingFeatureViewController: RouteFindingThumbnailCollectionViewCellDelegate {
    func enterDeletePageMode(indexPath: IndexPath) {
        thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        showDeleteView(for: indexPath)
        
        UIView.animate(withDuration: 0.2) {
            self.deleteImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
}
