//
//  RouteFindingSectionViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/24.
//

import UIKit

class RouteFindingSectionViewController: UIViewController {

    lazy var routeFindingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.headerReferenceSize = .init(width: 100, height: 76)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
