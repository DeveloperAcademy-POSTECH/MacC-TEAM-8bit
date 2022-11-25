//
//  RouteFindingSectionViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/24.
//

import UIKit

class RouteFindingSectionViewController: UIViewController {
    
    var infoArr = [1,2,3,3,4,5,5,6,7,5]
    var dictionarySelectedIndexPath: [IndexPath : Bool] = [:]
    var mMode: RouteFindingCollectionViewMode = .view {
        didSet{
            switch mMode{
            case .view:
                for (key,value) in dictionarySelectedIndexPath{
                    if value{
                        routeFindingCollectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                routeFindingCollectionView.allowsMultipleSelection = false
            case .select:
                routeFindingCollectionView.allowsMultipleSelection = true
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
        cv.backgroundColor = .orrGray100
        return cv
    }()
    
    lazy var bottomOptionView :UIView = {
        let view = UIView()
        view.backgroundColor = .orrUPBlue
        view.layer.opacity = 0.0
        return view
    }()
    
    lazy var folderButton : ImageButton = {
        let view = ImageButton()
        view.setImage(UIImage(systemName: "folder.fill"), for: .normal)
        view.setTitle("이동", for: .normal)
        view.isEnabled = false
        view.addTarget(self, action: #selector(touchFolderButton), for: .touchUpInside)
        return view
    }()
    
    lazy var deleteButton : ImageButton = {
        let view = ImageButton()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        mMode = .view
        bottomOptionView.layer.opacity = 0.0
        routeFindingCollectionView.reloadSections(IndexSet(integer: 0))
        
        (routeFindingCollectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as? RouteFindingCollectionViewHeaderCell)?.subTitleButton.setTitle(mMode == .select ? "완료" : "편집", for: .normal)
        (routeFindingCollectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as?
         RouteFindingCollectionViewHeaderCell)?.subTitleButton.setTitleColor(mMode == .select ? UIColor.orrUPBlue: UIColor.orrGray400, for: .normal)
        
        self.deleteButton.isEnabled = false
        self.folderButton.isEnabled = false
        
    }
    func setDelegate(){
        routeFindingCollectionView.delegate = self
        routeFindingCollectionView.dataSource = self
        routeFindingCollectionView.showsVerticalScrollIndicator = false
    }
    
    func registerCells() {
        routeFindingCollectionView.register(RouteFindingCollectionViewCustomCell.self, forCellWithReuseIdentifier: "RouteFindingCollectionViewCustomCell")
        
        routeFindingCollectionView.register(
            RouteFindingCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "RouteFindingCollectionViewHeaderCell"
        )
    }
    
    func setUpLayout(){
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
    }
    
    @objc func touchDeleteButton(){
        let vc = UIViewController()
        vc.view.backgroundColor = .systemYellow
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 235
                }
            ]
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc func touchFolderButton(){
        let vc = UIViewController()
        vc.view.backgroundColor = .systemYellow
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 235
                }
            ]
        }
        present(vc, animated: true, completion: nil)
    }
}
