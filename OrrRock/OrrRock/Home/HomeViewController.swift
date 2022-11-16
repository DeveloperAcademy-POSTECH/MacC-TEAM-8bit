//
//  HomeCollectionViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

import PhotosUI
import UIKit

import BetterSegmentedControl
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
            homeTableView.reloadData()
            homeTableView.separatorStyle = isCardView ? .none : .singleLine
        }
    }
    
    var sortOption: SortOption = .gymVisitDate {
        didSet {
            reloadTableViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        }
    }
    
    var orderOption: OrderOption = .ascend {
        didSet {
            reloadTableViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        }
    }
    var filterOption: FilterOption = .all {
        didSet {
            reloadTableViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        }
    }
    
    private let headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.orrGray1!.cgColor, UIColor.orrGray1!.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.75, 0.9]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "모든 기록"
        view.font = .systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    private let uploadButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "upload icon"), for: .normal)
        view.addTarget(self, action: #selector(videoButtonPressed), for: .touchUpInside)
        return view
    }()
    
    
    private lazy var quickActionButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(title: "", handler: { _ in}))
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        button.tintColor = .orrGray3
        
        // QuickAction은 UIMenu() 라는 컴포넌트로 구현할 수 있음
        // 버튼의 menu에 UIMenu로 감싼 UIAction들을 담아주기
        // UIMenu는 Action에 대한 그룹핑 역할. displayInline을 빼면 폴더링이 되어 접힘
        // UIDeferredMenuElement를 통해 동적으로 UI가 변경될 수 있도록 정의
        button.menu = UIMenu(options: .displayInline, children: [
            UIDeferredMenuElement.uncached { [weak self] completion in
                let actions = [
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
    
    lazy var homeTableView: UITableView = {
        var view = UITableView(frame: CGRect.zero, style: .grouped)
        
        view.register(HomeTableViewCardCell.classForCoder(), forCellReuseIdentifier: HomeTableViewCardCell.identifier)
        view.register(HomeTableViewListCell.classForCoder(), forCellReuseIdentifier: HomeTableViewListCell.identifier)
        view.register(HomeTableViewHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: HomeTableViewHeader.identifier)
        view.register(HomeTableViewFooter.classForCoder(), forHeaderFooterViewReuseIdentifier: HomeTableViewFooter.identifier)
        
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        
        // 앨범형, 목록형 셀 간격을 맞추기 위한 offset을 적용
        view.sectionHeaderTopPadding = CGFloat(OrrPadding.padding3.rawValue - 4)
        
        return view
    }()
    
    // 영상이 없을 때 띄워주는 placeholder
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
    
    // 세그먼트 컨트롤
    private lazy var tableViewSegmentControl: BetterSegmentedControl = {
        let view = BetterSegmentedControl(
            frame: CGRect(x: 0.0, y: 380.0, width: 160, height: 30.0),
            segments: IconSegment.segments(withIcons: [UIImage(systemName: "square.split.2x2.fill")!, UIImage(systemName:  "list.bullet")!],
                                           iconSize: CGSize(width: 24.0, height: 24.0),
                                           normalIconTintColor: .orrGray3!,
                                           selectedIconTintColor: UIColor.orrUPBlue!),
            options: [.cornerRadius(25.0),
                      .backgroundColor(UIColor.orrGray2!),
                      .indicatorViewBackgroundColor(.white)])
        view.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        
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
        setUICollectionViewDelegate()
        sortedVideoInfoData = DataManager.shared.sortRepository(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        flattenSortedVideoInfoData = sortedVideoInfoData.flatMap({ $0 })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        reloadTableViewWithOptions(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: Layout Function
    private func setUpLayout() {
        
        self.view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(115)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(OrrPadding.padding3.rawValue)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(OrrPadding.padding3.rawValue)
        }
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(160)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat(OrrPadding.padding2.rawValue))
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(CGFloat(OrrPadding.padding3.rawValue))
        }
        
        self.view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-CGFloat(OrrPadding.padding3.rawValue))
        }
        
        self.view.addSubview(quickActionButton)
        quickActionButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalTo(uploadButton.snp.leading).offset(-CGFloat(OrrPadding.padding2.rawValue))
        }
        
        self.view.addSubview(tableViewSegmentControl)
        tableViewSegmentControl.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(OrrPadding.padding6.rawValue))
            $0.leading.trailing.equalToSuperview().inset(CGFloat(OrrPadding.padding3.rawValue))
            $0.height.equalTo(48)
        }
        
        self.view.addSubview(placeholderView)
        placeholderView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(OrrPadding.padding3.rawValue)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(OrrPadding.padding3.rawValue)
        }
    }
    
    private func setUICollectionViewDelegate() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
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
    
    @objc func segmentControl(_ sender: BetterSegmentedControl) {
        isCardView = sender.index == 0
    }
}

// QuickAction을 통한 정렬 및 필터링 시 함수를 아래에 구현
extension HomeViewController {
    // 정렬 기준 함수
    private func reloadTableViewWithOptions(filterOption: FilterOption, sortOption: SortOption, orderOption: OrderOption) {
        
        self.sortedVideoInfoData = DataManager.shared.sortRepository(filterOption: filterOption, sortOption: sortOption, orderOption: orderOption)
        self.flattenSortedVideoInfoData = sortedVideoInfoData.flatMap { $0 }
        
        placeholderView.alpha = flattenSortedVideoInfoData.isEmpty ? 1 : 0
        homeTableView.alpha = flattenSortedVideoInfoData.isEmpty ? 0 : 1
        
        self.homeTableView.reloadData()
    }
}
