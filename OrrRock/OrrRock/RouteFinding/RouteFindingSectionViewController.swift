//
//  RouteFindingSectionViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/24.
//

import UIKit

class RouteFindingSectionViewController: UIViewController {
    
    var routeInformations: [RouteInformation]!
    var dictionarySelectedIndexPath: [IndexPath : Bool] = [:]
    var routeFindingDataManager: RouteDataManager?
    var sectionKind: RouteFindingSection?
    let minimumInteritemSpacingForSection: CGFloat = 13
    let minimumLineSpacingForSection: CGFloat = 16
    let cellScaleBetweenWidthAndHeight = 1.8
    let headerIdentifier = "UICollectionElementKindSectionHeader"
    
    var mMode: RouteFindingCollectionViewMode = .view {
        didSet{
            switch mMode{
            case .view:
                self.tabBarController?.tabBar.isHidden = false
                bottomOptionView.layer.opacity = 0.0
                for (key,value) in dictionarySelectedIndexPath{
                    if value{
                        routeFindingCollectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                routeFindingCollectionView.allowsMultipleSelection = false
                routeFindingCollectionView.reloadSections(IndexSet(integer: 0))
                let supplementaryViewSectionHeader = routeFindingCollectionView.supplementaryView(forElementKind: headerIdentifier, at: IndexPath(row: 0, section: 0)) as? RouteFindingCollectionViewHeaderCell
                
                supplementaryViewSectionHeader?.subTitleButton.setTitle(mMode == .select ? "완료" : "편집", for: .normal)
                supplementaryViewSectionHeader?.subTitleButton.setTitleColor(mMode == .select ? UIColor.orrUPBlue: UIColor.orrGray400, for: .normal)
            case .select:
                self.tabBarController?.tabBar.isHidden = true
                bottomOptionView.layer.opacity = 1.0
                routeFindingCollectionView.allowsMultipleSelection = true
                routeFindingCollectionView.reloadSections(IndexSet(integer: 0))
                let supplementaryViewSectionHeader = routeFindingCollectionView.supplementaryView(forElementKind: headerIdentifier, at: IndexPath(row: 0, section: 0)) as? RouteFindingCollectionViewHeaderCell
                
                supplementaryViewSectionHeader?.subTitleButton.setTitle(mMode == .select ? "완료" : "편집", for: .normal)
                supplementaryViewSectionHeader?.subTitleButton.setTitleColor(mMode == .select ? UIColor.orrUPBlue: UIColor.orrGray400, for: .normal)
            }
        }
    }
    
    lazy var routeFindingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 64)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .orrGray050
        return cv
    }()
    
    lazy var emptyGuideView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray050
        view.alpha = 0.0
        return view
    }()
    
    private lazy var emptyGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "풀고 싶은 문제가 있나요?\n상단 업로드를 통해 루트 파인딩을 추가하세요"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.textColor = .orrGray500
        return label
    }()
    
    private lazy var bottomOptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrUPBlue
        view.layer.opacity = 0.0
        return view
    }()
    
    lazy var folderButton: VerticalAlignImageTextButton = {
        let view = VerticalAlignImageTextButton ()
        view.setImage(UIImage(systemName: "folder.fill"), for: .normal)
        view.setTitle("이동", for: .normal)
        view.isEnabled = false
        view.addTarget(self, action: #selector(touchFolderButton), for: .touchUpInside)
        return view
    }()
    
    lazy var deleteButton: VerticalAlignImageTextButton = {
        let view = VerticalAlignImageTextButton ()
        view.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        view.setTitle("삭제", for: .normal)
        view.isEnabled = false
        view.addTarget(self, action: #selector(touchDeleteButton), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        registerCells()
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initRouteInformations()
        routeFindingCollectionView.reloadData()
        emptyGuideView.alpha = routeInformations.count == 0 ? 1.0 : 0.0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mMode = .view
        changeStatusOfChangeFolderButtons(to: false)
    }
    private func setDelegate() {
        routeFindingCollectionView.delegate = self
        routeFindingCollectionView.dataSource = self
        routeFindingCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func registerCells() {
        routeFindingCollectionView.register(RouteFindingCollectionViewCustomCell.self, forCellWithReuseIdentifier: "RouteFindingCollectionViewCustomCell")
        
        routeFindingCollectionView.register(
            RouteFindingCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "RouteFindingCollectionViewHeaderCell"
        )
    }
    
    private func setUpLayout() {
        view.addSubview(routeFindingCollectionView)
        routeFindingCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(bottomOptionView)
        bottomOptionView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp_bottomMargin)
        }
        
        bottomOptionView.addSubview(folderButton)
        folderButton.snp.makeConstraints {
            $0.top.equalTo(bottomOptionView.snp.top).offset(0)
            $0.leading.equalToSuperview().inset(82.5)
        }
        
        bottomOptionView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(bottomOptionView.snp.top).offset(0)
            $0.trailing.equalToSuperview().inset(82.5)
        }
        
        view.addSubview(emptyGuideView)
        emptyGuideView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emptyGuideView.addSubview(emptyGuideLabel)
        emptyGuideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.snp.bottom).offset(-UIScreen.main.bounds.height / 2)
        }
    }
    
    @objc func touchDeleteButton() {
        let vc = RouteModalViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.isFoldering = false
        vc.delegate = self
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 235
                }
            ]
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc func touchFolderButton() {
        let vc = RouteModalViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.isFoldering = true
        vc.delegate = self
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 235
                }
            ]
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func initRouteInformations() {
        print("inittt")
        switch sectionKind{
        case .all:
            routeInformations = routeFindingDataManager?.getRouteFindingList().sorted { $1.dataWrittenDate < $0.dataWrittenDate }
        case .challenge:
            routeInformations = routeFindingDataManager?.getSpecificRouteFindingList(isChallengeComplete: false).sorted { $1.dataWrittenDate < $0.dataWrittenDate }
        case .success:
            routeInformations = routeFindingDataManager?.getSpecificRouteFindingList(isChallengeComplete: true).sorted { $1.dataWrittenDate < $0.dataWrittenDate }
        case .none:
            break
        }
        
    }
}
