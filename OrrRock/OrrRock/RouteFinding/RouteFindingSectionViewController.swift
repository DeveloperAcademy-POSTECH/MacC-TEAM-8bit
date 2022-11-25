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
//                selectBarButton.title = "편집"
//                (routeFindingCollectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(item: 0, section: 0))).subti
                routeFindingCollectionView.allowsMultipleSelection = false
            case .select:
//                selectBarButton.title = "취소"
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        registerCells()
        setUpLayout()
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
    }
}
