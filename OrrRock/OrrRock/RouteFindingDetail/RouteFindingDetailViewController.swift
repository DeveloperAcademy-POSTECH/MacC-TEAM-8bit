//
//  RouteFindingDetailViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/29.
//

import UIKit

import SnapKit

class RouteFindingDetailViewController: UIViewController {
    
    // MARK: Variables
    
    var isShowingInfo: Bool = false
    var currentIndex: Int = 0
    var pendingIndex: Int? = 0
    
    private var infoButton: UIBarButtonItem!
    private var trashButton: UIBarButtonItem!
    
    var routeDataDraft: RouteDataDraft
    
    var centerCell: RouteFindingThumbnailCollectionViewCell?
    private var beforeCell: RouteFindingThumbnailCollectionViewCell?
    private var afterCell: RouteFindingThumbnailCollectionViewCell?
    
    var viewControllerListForPageVC: [UIViewController]!
    
    // MARK: View Components
    
    private lazy var topSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray100
        return view
    }()
    
    private lazy var bottomSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray100
        return view
    }()
    
    private lazy var routePageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.view.backgroundColor = .black
        pageViewController.isPagingEnabled = false
        return pageViewController
    }()
    
    let thumbnailCollectionView: UICollectionView = {
        let layout = RouteFindingThumbnailCollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = .orrGray100
        collection.showsHorizontalScrollIndicator = false
        collection.register(RouteFindingThumbnailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: RouteFindingThumbnailCollectionViewCell.identifier)
        
        collection.isUserInteractionEnabled = false
        
        return collection
    }()
    
    private lazy var routeInfoView: RouteInfoView = {
        let view = RouteInfoView(routeDataDraft: routeDataDraft)
        
        return view
    }()
    
    // MARK: Life Cycle Functions
    
    init(routeDataDraft: RouteDataDraft) {
        self.routeDataDraft = routeDataDraft
        
        super.init(nibName: nil, bundle: nil)
        
        setUpLayout()
        setNavigationBar()
        setUpPageViewController()
        setUpCollectionView()
        addUIGesture()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(respondToTapGesture(_:)))
        view.addGestureRecognizer(tapgesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        loadPageViewControllerList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .black
        
        // CollectionView??? ??? ???????????? ??? ???, CollectionView??? content??? Inset??? ?????? ????????? ???????????? ??????????????? ??????
        let layoutMargins: CGFloat = self.thumbnailCollectionView.layoutMargins.left
        let sideInset = self.view.frame.width / 2 - layoutMargins
        self.thumbnailCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        // ?????? ???????????? ?????? ?????? ???????????? ??????
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: Functions
    
    // ?????????????????? ?????? ??????
    func setNavigationBar() {
        // ?????????????????? ?????? ????????? ??????
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let editButton = UIBarButtonItem(title: "??????", style: .plain, target: self, action: #selector(editAction))
        self.navigationController?.setExpansionBackbuttonArea()
        self.navigationItem.rightBarButtonItem = editButton
        
        // ?????????????????? ???????????? ??? ????????? ??? ?????????
        navigationController?.isToolbarHidden = false
        
        // ??????, ??????????????????, ?????? ??? ??????
        
        // ?????? ?????? ????????? ??????
        infoButton = UIBarButtonItem(image: UIImage(systemName: isShowingInfo ? "info.circle.fill" : "info.circle"), style: .plain, target: self, action: #selector(showInfo))
        trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteVideoAction))
        
        self.toolbarItems = [infoButton,flexibleSpace,trashButton]
    }
    
    // ????????? ???????????? ??? ??????????????????, ????????? ???????????? ??????
    override func viewWillLayoutSubviews() {
        // ????????????????????? ???????????? ??? ????????? ??????
        let isNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
        let backGroundColor = UIColor.black
        
        view.backgroundColor = backGroundColor
    }
    
    func getViewControllerForPageVC() -> [RouteViewController] {
        var routeViewControllers: [RouteViewController] = []
        routeDataDraft.routeInfoForUI.pages.forEach { pageInfo in
            routeViewControllers.append(RouteViewController(pageInfo: pageInfo, backgroundImage: routeDataDraft.routeInfoForUI.imageLocalIdentifier.generateCardViewThumbnail(targetSize: CGSize(width: 2400, height: 2400))))
        }
        
        return routeViewControllers
    }
    
    // MARK: @objc Functions
    
    @objc func showInfo() {
        isShowingInfo.toggle()
        infoButton.image = UIImage(systemName: isShowingInfo ? "info.circle.fill" : "info.circle")
        
        if isShowingInfo {
            UIView.animate(withDuration: 0.2, animations: {
                self.routeInfoView.transform = CGAffineTransform(translationX: 0, y: -330)
                self.routePageViewController.view.transform = CGAffineTransform(translationX: 0, y: -100)
                self.navigationController?.isNavigationBarHidden = true
                self.topSafeAreaView.layer.opacity = 0
                self.navigationController?.isToolbarHidden = false
//                self.bottomSafeAreaView.layer.opacity = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.routeInfoView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.routePageViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.navigationController?.isNavigationBarHidden = false
                self.topSafeAreaView.layer.opacity = 1
            })
        }
    }
    
    @objc func editAction() {
        guard let image = routeDataDraft.routeInfoForUI.imageLocalIdentifier.generateCardViewThumbnail(targetSize: CGSize(width: 2400, height: 2400)) else { return }
        
        let featureVC = RouteFindingFeatureViewController(routeDataDraft: routeDataDraft, backgroundImage: image, isCreateMode: false)
        
        featureVC.modalPresentationStyle = .fullScreen
        navigationController?.present(featureVC, animated: true)
    }
    
    // ???????????? ????????? ????????? ??? ??????
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    // ?????? ????????? ????????? ??? ??????
    @objc func deleteVideoAction(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: "????????? ?????? ????????? ????????????", message: "????????? ??????????????????????", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "??????", style: .destructive) {_ in
            self.routeDataDraft.routeDataManager.deleteRouteData(routeInformation: self.routeDataDraft.route!)
            self.goBackAction()
        }
        let cancelAction = UIAlertAction(title: "??????", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func respondToTapGesture(_ gesture: UITapGestureRecognizer) {
        if !isShowingInfo {
            self.topSafeAreaView.layer.opacity = self.navigationController!.isToolbarHidden ? 1.0 : 0.0
            self.bottomSafeAreaView.layer.opacity = self.navigationController!.isToolbarHidden ? 1.0 : 0.0
            self.navigationController?.isNavigationBarHidden = self.navigationController!.isToolbarHidden ? false : true
            self.navigationController?.isToolbarHidden = self.navigationController!.isToolbarHidden ? false : true
            
            self.thumbnailCollectionView.backgroundColor = self.navigationController!.isToolbarHidden ? .black : .orrGray100
        }
    }
}

extension RouteFindingDetailViewController {
    
    // MARK: Set Up Functions
    
    private func setUpLayout() {
        
        view.addSubview(routePageViewController.view)
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.windows.first
        let contentHeight = view.frame.height - (window?.safeAreaInsets.top)! + (window?.safeAreaInsets.bottom)!
        let contentWidth = view.frame.width
        let widthFirst: Bool = contentWidth < (contentHeight - 69) * 9 / 16
        routePageViewController.view.snp.makeConstraints {
            if widthFirst {
                $0.width.equalTo(contentWidth)
                $0.height.equalTo(contentWidth * 16 / 9)
            } else {
                $0.height.equalTo(contentHeight - 69)
                $0.width.equalTo((contentHeight - 69) * 9 / 16)
            }
            $0.center.equalToSuperview()
        }
        
        view.addSubview(topSafeAreaView)
        topSafeAreaView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.top.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(bottomSafeAreaView)
        bottomSafeAreaView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.bottom.equalTo(self.view)
        }
        
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            $0.height.equalTo(74)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(routeInfoView)
        routeInfoView.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.height.equalTo(450)
            $0.bottom.equalTo(self.view).offset(450)
        }
    }
    
    private func setUpPageViewController() {
        routePageViewController.delegate = self
        routePageViewController.dataSource = self
    }
    
    private func loadPageViewControllerList() {
        viewControllerListForPageVC = getViewControllerForPageVC()
        routePageViewController.setViewControllers([viewControllerListForPageVC.first!], direction: .forward, animated: true)
        thumbnailCollectionView.reloadData()
    }
    
    private func setUpCollectionView() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
}
