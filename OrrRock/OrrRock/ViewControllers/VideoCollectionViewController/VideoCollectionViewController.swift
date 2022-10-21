//
//  VideoCollectionViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/20.
//

import UIKit

class VideoCollectionViewController: UIViewController {
    
    var imageArr = ["as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5"]
    
    enum Mode{
        case view
        case select
    }
    
    var dictionarySelectedIndecPath : [IndexPath : Bool] = [:]
    var mMode: Mode = .view {
        didSet{
            switch mMode{
            case .view:
                for (key,value) in dictionarySelectedIndecPath{
                    if value{
                        videoCollectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndecPath.removeAll()
                selectBarButton.title = "편집"
                navigationItem.leftBarButtonItem = backBarButton
                videoCollectionView.allowsMultipleSelection = false
            case .select:
                selectBarButton.title = "취소"
                navigationItem.leftBarButtonItem = deleteBarButton
                videoCollectionView.allowsMultipleSelection = true
            }
        }
    }
    
    lazy var selectBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
    }()
    
    lazy var backBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image:UIImage(systemName: "chevron.backward"),style: .plain, target: self, action: #selector(didBackButtonClicked(_:)))
        return barButtonItem
    }()
    
    lazy var deleteBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
        return barButtonItem
    }()
    
     lazy var videoCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.headerReferenceSize = .init(width: 100, height: 76)
        layout.footerReferenceSize = .init(width: 50, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setVideoCollectionViewDelegate()
        registerCells()
        setUpLayout()
        // Do any additional setup after loading the view.
    }
    
    func setVideoCollectionViewDelegate() {
        videoCollectionView.dataSource = self
        videoCollectionView.delegate = self
    }
    
    func registerCells(){
        videoCollectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "customVideoCollectionCell")
        videoCollectionView.register(
            VideoCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: VideoCollectionViewHeaderCell.id
        )
        
        videoCollectionView.register(
            VideoCollectionFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: VideoCollectionFooterCell.id + "footer"
        )
    }
    
    private func setUpLayout(){
        view.addSubview(videoCollectionView)
        videoCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
                .inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        navigationItem.rightBarButtonItem = selectBarButton
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem){
        mMode = mMode == .view ? .select : .view
    }
    
    @objc func didBackButtonClicked(_ sender: UIBarButtonItem){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem){
        var deleteNeededIndexPaths : [IndexPath] = []
        for (key,value) in dictionarySelectedIndecPath{
            if value{
                deleteNeededIndexPaths.append(key)
            }
        }
        //삭제 실제 배열에서
        for i in deleteNeededIndexPaths.sorted(by:{$0.item > $1.item
        }){
            imageArr.remove(at: i.item)
        }
        
        videoCollectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndecPath.removeAll()
    }
    
}
