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
        
        let myPageButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle"), style: .plain, target: self, action: nil)
        let addVideoButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: self, action: #selector(videoButtonPressed))
        // toolbar 내 Spacer() 역할
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: HomeViewController.self, action: nil)
        
        items.append(myPageButton)
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
        
        setUpLayout()
        setUpNavigationBar()
        setUICollectionViewDelegate()
        
        addDummyData()
        
        DEBUGvideoData = DataManager.shared.sortRepository(filterOption: .all, sortOption: .gymVisitDate, orderOption: .ascend)
        DEBUGflattenVideoData = DEBUGvideoData.flatMap({ $0 })
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
    }
    
    private func setUICollectionViewDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: quickActionButton)
    }
    
    @objc func switchViewStyle() {
        isCardView.toggle()
    }
    
    @objc func videoButtonPressed(sender: UIButton){
        let nextVC = DateSettingViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    // DEBUG
    var DEBUGMakevideoData: [[VideoInfo]] = []
    var DEBUGMakeflattenVideoData: [VideoInfo] = []
    
    var DEBUGvideoData: [[VideoInformation]] = []
    var DEBUGflattenVideoData: [VideoInformation] = []
}

// QuickAction을 통한 정렬 및 필터링 시 함수를 아래에 구현
extension HomeViewController {
    // 정렬 기준 함수
    func reloadCollectionViewWithOptions(filterOption: FilterOption, sortOption: SortOption, orderOption: OrderOption) {

        self.DEBUGvideoData = DataManager.shared.sortRepository(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        self.DEBUGflattenVideoData = DEBUGvideoData.flatMap { $0 }
        
        self.collectionView.reloadData()
    }
}

// DEBUG
extension HomeViewController {
    func addDummyData() {
        // DEBUG
        DataManager.shared.deleteAllData()
        
        DEBUGMakevideoData = [[
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Date(), videoLocalIdentifier: "D150F80C-ABFA-4EAB-8CA5-80BBF39ECA01/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Date(), videoLocalIdentifier: "E4E40C15-B932-431A-B440-0ADBFE19E022/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Date(), videoLocalIdentifier: "BED792BC-AA01-435F-BE2B-D460008807C4/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Date(), videoLocalIdentifier: "AFF9F7BB-1D37-4217-BD3B-35CAF076773B/L0/001", problemLevel: 3, isSucceeded: false),
        ],[
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, videoLocalIdentifier: "65B23455-6709-43C0-A90C-A89E52937050/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, videoLocalIdentifier: "836486C1-D52F-4F66-AAFC-00203F3F221D/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, videoLocalIdentifier: "3F643207-2002-41C0-BDAD-3CD207EB987E/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, videoLocalIdentifier: "7194A843-1842-4FB6-A8AC-E0742C0B981B/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, videoLocalIdentifier: "D150F80C-ABFA-4EAB-8CA5-80BBF39ECA01/L0/001", problemLevel: 3, isSucceeded: false),
        ],[
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "9C1C5CF8-9F72-4BDE-BEFC-0F098D0651EE/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "9C1C5CF8-9F72-4BDE-BEFC-0F098D0651EE/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "BC19B352-D956-403A-B118-D8A64EBF32A6/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "28A84914-E7FF-41C8-BC00-508981928EDA/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "53ED528F-9047-4799-8378-F3451E7B9CF0/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "아띠 클라이밍", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "3DDCC03C-2197-42D6-A557-DFF28B09EC04/L0/001", problemLevel: 3, isSucceeded: false),
        ],[
            VideoInfo(gymName: "스파이더", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "9C1C5CF8-9F72-4BDE-BEFC-0F098D0651EE/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "스파이더", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "9C1C5CF8-9F72-4BDE-BEFC-0F098D0651EE/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "스파이더", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "BC19B352-D956-403A-B118-D8A64EBF32A6/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "스파이더", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "28A84914-E7FF-41C8-BC00-508981928EDA/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "스파이더", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "53ED528F-9047-4799-8378-F3451E7B9CF0/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "스파이더", gymVisitDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, videoLocalIdentifier: "3DDCC03C-2197-42D6-A557-DFF28B09EC04/L0/001", problemLevel: 3, isSucceeded: true),
        ],[
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, videoLocalIdentifier: "65B23455-6709-43C0-A90C-A89E52937050/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, videoLocalIdentifier: "836486C1-D52F-4F66-AAFC-00203F3F221D/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, videoLocalIdentifier: "3F643207-2002-41C0-BDAD-3CD207EB987E/L0/001", problemLevel: 3, isSucceeded: false),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, videoLocalIdentifier: "7194A843-1842-4FB6-A8AC-E0742C0B981B/L0/001", problemLevel: 3, isSucceeded: true),
            VideoInfo(gymName: "김대우", gymVisitDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, videoLocalIdentifier: "D150F80C-ABFA-4EAB-8CA5-80BBF39ECA01/L0/001", problemLevel: 3, isSucceeded: true),
        ]]
        
        DEBUGMakeflattenVideoData = DEBUGMakevideoData.flatMap({ $0 })
        
        DataManager.shared.createMultipleData(infoList: DEBUGMakeflattenVideoData)
    }
}
