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

import PhotosUI
import UIKit

import NVActivityIndicatorView
import SnapKit

final class HomeViewController : UIViewController {
    
    // MARK: variables
    // CollectionView DataSource로 사용될 배열
    var sortedVideoInfoData: [[VideoInformation]] = []
    var flattenSortedVideoInfoData: [VideoInformation] = []
    
    // Quick Action 기능을 위한 조건 변수와 함수 호출 설정
    var isCardView: Bool = true {
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            quickActionButton.setImage(UIImage(systemName: isCardView ? "rectangle.stack" : "list.bullet"), for: .normal)
        }
    }
    
    var sortOption: SortOption = .gymVisitDate {
        didSet {
            reloadCollectionViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        }
    }
    
    var orderOption: OrderOption = .ascend {
        didSet {
            reloadCollectionViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        }
    }
    var filterOption: FilterOption = .all {
        didSet {
            reloadCollectionViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
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
    
    private lazy var logoView: UIView = {
        // 앱 로고와 타이틀 디자인이 확정나면 이 컴포넌트를 활용해 그려주기
        let view = UIImageView(image: UIImage(named: "orrrock_logo"))
        return view
    }()
    
    private lazy var quickActionButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(title: "", handler: { _ in}))
        button.setImage(UIImage(systemName: isCardView ? "rectangle.stack" : "list.bullet"), for: .normal)
        button.tintColor = .orrUPBlue
        
        // QuickAction은 UIMenu() 라는 컴포넌트로 구현할 수 있음
        // 버튼의 menu에 UIMenu로 감싼 UIAction들을 담아주기
        // UIMenu는 Action에 대한 그룹핑 역할. displayInline을 빼면 폴더링이 되어 접힘
        // UIDeferredMenuElement를 통해 동적으로 UI가 변경될 수 있도록 정의
        button.menu = UIMenu(options: .displayInline, children: [
            UIDeferredMenuElement.uncached { [weak self] completion in
                let actions = [
                    UIMenu(title: "", options: .displayInline, children: [
                        // 앨범형으로 보기
                        UIAction(title: "앨범",
                                 image: UIImage(systemName: "rectangle.stack"),
                                 state: self!.isCardView ? .on : .off) { [unowned self] _ in
                                     self?.isCardView = true
                                 },
                        // 목록형으로 보기
                        UIAction(title: "목록",
                                 image: UIImage(systemName: "list.bullet"),
                                 state: self!.isCardView ? .off : .on) { [unowned self] _ in
                                     self?.isCardView = false
                                 }
                    ]),
                    UIMenu(title: "", options: .displayInline, children: [
                        // 날짜 기준으로 정렬
                        UIAction(title: "날짜",
                                 image: self!.sortOption == .gymVisitDate ? ( self!.orderOption == .ascend ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")) : nil,
                                 state: self!.sortOption == .gymVisitDate ? .on : .off) { [unowned self] _ in
                                     if self!.sortOption == .gymVisitDate {
                                         // 이미 날짜 기준으로 정렬 중이라면
                                         self?.orderOption = self!.orderOption == .ascend ? .descend : .ascend
                                     } else {
                                         // 암장 기준으로 정렬 중이라면
                                         self?.sortOption = .gymVisitDate
                                         self?.orderOption = .ascend
                                     }
                                 },
                        // 암장 기준으로 정렬하기
                        UIAction(title: "클라이밍 장",
                                 image: self!.sortOption == .gymVisitDate ? nil : ( self!.orderOption == .ascend ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")),
                                 state: self!.sortOption == .gymVisitDate ? .off : .on) { [unowned self] _ in
                                     
                                     if self!.sortOption == .gymVisitDate {
                                         // 날짜 기준으로 정렬 중이라면
                                         self?.sortOption = .gymName
                                         self?.orderOption = .ascend
                                     } else {
                                         // 이미 암장 기준으로 정렬 중이라면
                                         self?.orderOption = self!.orderOption == .ascend ? .descend : .ascend
                                     }
                                 }
                    ]),
                    UIMenu(title: "", options: .displayInline, children: [
                        // 모든 비디오 보여주기
                        UIAction(title: "모든 비디오",
                                 image: UIImage(systemName: "photo.on.rectangle.angled"),
                                 state: self!.filterOption == .all ? .on : .off) { [unowned self] _ in
                                     self!.filterOption = .all as FilterOption
                                 },
                        // 즐겨찾는 항목만 보여주기
                        UIAction(title: "즐겨찾는 항목",
                                 image: UIImage(systemName: "heart"),
                                 state: self!.filterOption == .favorite ? .on : .off) { [unowned self] _ in
                                     self!.filterOption = .favorite as FilterOption
                                 },
                        // 성공 영상만 보여주기
                        UIAction(title: "성공",
                                 image: UIImage(systemName: "circle"),
                                 state: self!.filterOption == .success ? .on : .off) { [unowned self] _ in
                                     self!.filterOption = .success as FilterOption
                                 },
                        // 실패 영상만 보여주기
                        UIAction(title: "실패",
                                 image: UIImage(systemName: "multiply"),
                                 state: self!.filterOption == .failure ? .on : .off) { [unowned self] _ in
                                     self!.filterOption = .failure as FilterOption
                                 }
                    ])
                ]
                completion(actions)
            }
        ])
        
        // 버튼을 눌렀을 때 메뉴를 보여주도록 설정
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    private lazy var toolbarView: UIToolbar = {
        let view = UIToolbar()
        
        var items: [UIBarButtonItem] = []
        
        // 이번 스프린트에서는 기능이 없음
//        let myPageButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle"), style: .plain, target: self, action: nil)
        
        let addVideoButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: self, action: #selector(videoButtonPressed))
        // toolbar 내 Spacer() 역할
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: HomeViewController.self, action: nil)
        
//        items.append(myPageButton)
        items.append(flexibleSpace)
        items.append(addVideoButton)
        
        items.forEach { (item) in
            item.tintColor = .orrUPBlue
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
    
    private lazy var placeholderView: UILabel = {
        let view = UILabel()
        view.text = "업로드한 비디오가 없습니다.\n비디오를 업로드 해주세요."
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .orrGray4
        view.font = .systemFont(ofSize: 15)
        
        view.alpha = 0.0
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
        view.backgroundColor = .orrGray1

        showOnBoard()

        setUpLayout()
        setUpNavigationBar()
        setUICollectionViewDelegate()
        sortedVideoInfoData = DataManager.shared.sortRepository(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        flattenSortedVideoInfoData = sortedVideoInfoData.flatMap({ $0 })
        
        printVideoInformation(videoInformation: sortedVideoInfoData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.backgroundColor = .clear
        reloadCollectionViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
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
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(orrPadding.padding3.rawValue)
        }
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.forLastBaselineLayout.snp_topMargin).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        self.view.addSubview(placeholderView)
        placeholderView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(toolbarView.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(orrPadding.padding3.rawValue)
        }
    }
    
    private func setUICollectionViewDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: quickActionButton)
    }
    
    private func showOnBoard(){
        if !UserDefaults.standard.bool(forKey: "watchOnBoard"){
            let onBoardingViewController = OnBoardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            self.navigationController?.pushViewController(onBoardingViewController, animated: true)
        }
    }
    @objc func switchViewStyle() {
        isCardView.toggle()
    }
    
    @objc func videoButtonPressed(sender: UIButton){
        let nextVC = DateSettingViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// QuickAction을 통한 정렬 및 필터링 시 함수를 아래에 구현
extension HomeViewController {
    // 정렬 기준 함수
    func reloadCollectionViewWithOptions(filterOption: FilterOption, sortOption: SortOption, orderOption: OrderOption) {
        
        self.sortedVideoInfoData = DataManager.shared.sortRepository(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        self.flattenSortedVideoInfoData = sortedVideoInfoData.flatMap { $0 }
        
        placeholderView.alpha = flattenSortedVideoInfoData.isEmpty ? 1 : 0
        collectionView.alpha = flattenSortedVideoInfoData.isEmpty ? 0 : 1

        self.collectionView.reloadData()
    }
}


func printVideoInformation(videoInformation: [[VideoInformation]]) {
    print("DATA LIST INFORMATION")
    for i in 0..<videoInformation.count {
        var success = 0
        print("VideoInformation \(i)th Index Count: \(videoInformation[i].count)")
        for j in 0..<videoInformation[i].count {
            if videoInformation[i][j].isSucceeded == true {
                success += 1
            }
        }
        print("Pass: \(success) Failure: \(videoInformation[i].count - success)")
        print("-----------------")
    }
}
