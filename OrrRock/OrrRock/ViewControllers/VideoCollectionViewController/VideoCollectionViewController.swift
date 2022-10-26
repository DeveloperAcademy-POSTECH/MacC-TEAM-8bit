//
//  VideoCollectionViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/20.
//

import UIKit

class VideoCollectionViewController: UIViewController {
    
    var videoInformationArray: [VideoInformation] = []
    var sectionData : SectionData!
    var successCount : Int = 0
    // 썸네일은 videoInformationArray[n].videoLocalIdentifier.generateCardViewThumbnail(targetSize: CGSize) 을 통해 간편하게 생성 가능함!
    
    lazy var firstContentOffset : Float = 0.0
    lazy var checkFirstContentOffset : Bool = false
    
    enum Mode{
        case view
        case select
    }
    var dictionarySelectedIndexPath : [IndexPath : Bool] = [:]
    var mMode: Mode = .view {
        didSet{
            switch mMode{
            case .view:
                for (key,value) in dictionarySelectedIndexPath{
                    if value{
                        videoCollectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                selectBarButton.title = "편집"
                let indexCountLabel = UILabel()
                indexCountLabel.text = "항목 선택"
                toolbarText.customView = indexCountLabel
                navigationItem.leftBarButtonItem = backBarButton
                videoCollectionView.allowsMultipleSelection = false
                self.navigationController?.setToolbarHidden(true, animated: true)
            case .select:
                selectBarButton.title = "취소"
                navigationItem.leftBarButtonItem = selectAllButton
                videoCollectionView.allowsMultipleSelection = true
                self.navigationController?.setToolbarHidden(false, animated: true)
            }
        }
    }
    
    lazy var titleName : UILabel = {
        let label = UILabel()
        label.text = "김대우 암벽교실"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    lazy var subTitleName : UILabel = {
        let label = UILabel()
        label.text = "2022년 10월 22일"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.sizeToFit()
        return label
    }()
    
    lazy var titleStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleName,subTitleName])
        stack.axis = .vertical
        stack.frame.size.width = max(titleName.frame.width,subTitleName.frame.width)
        stack.frame.size.height = titleName.frame.height + subTitleName.frame.height
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()
    
    lazy var toolbarText : UIBarButtonItem = {
        let label = UILabel()
        label.text = "항목 선택"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let item = UIBarButtonItem(customView: label)
        return item
    }()
    
    lazy var selectBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
    }()
    
    lazy var selectAllButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "전체 선택", style: .plain, target: self, action: #selector(didSelectAllButtonClicked(_:)))
        return barButtonItem
    }()
    
    lazy var backBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image:UIImage(systemName: "chevron.backward"),style: .plain, target: self, action: #selector(didBackButtonClicked(_:)))
        return barButtonItem
    }()
    
    lazy var deleteBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteActionSheetClicked(_:)))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    lazy var videoCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.headerReferenceSize = .init(width: 100, height: 76)
        layout.footerReferenceSize = .init(width: 50, height: 120)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var bottomBatItems : [UIBarButtonItem] = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),toolbarText,UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),deleteBarButton]
    
    override func viewDidLayoutSubviews() {
        navigationItem.titleView = titleStackView
        if sectionData?.sortOption == .gymName{
            titleName.text = sectionData?.gymName
            subTitleName.text = "\(sectionData.primaryGymVisitDate.timeToString()) ~ \(sectionData.secondaryGymVisitDate!.timeToString())"
        }else{
            titleName.text = sectionData?.gymName
            subTitleName.text = sectionData?.primaryGymVisitDate.timeToString()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setVideoCollectionViewDelegate()
        registerCells()
        setUpLayout()
        getSuccessCount()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        videoInformationArray = sortVideoInformation(videoInformation: videoInformationArray, sectionData: sectionData)
        videoCollectionView.reloadData()
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
        self.toolbarItems = bottomBatItems
        navigationItem.rightBarButtonItem = selectBarButton
        navigationItem.leftBarButtonItem = backBarButton
        firstContentOffset = Float(videoCollectionView.contentOffset.y)
    }
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem){
        mMode = mMode == .view ? .select : .view
    }
    
    @objc func didBackButtonClicked(_ sender: UIBarButtonItem){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didDeleteButtonClicked(){
        var deleteNeededIndexPaths : [IndexPath] = []
        for (key,value) in dictionarySelectedIndexPath{
            if value{
                deleteNeededIndexPaths.append(key)
            }
        }
        //삭제 실제 배열에서
        for i in deleteNeededIndexPaths.sorted(by:{$0.item > $1.item
        }){
            DataManager.shared.deleteData(videoInformation: videoInformationArray[i.item])
            videoInformationArray.remove(at: i.item)
            // 삭제 하는 코어데이터 함수
            
        }
        
        videoCollectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
        let indexCountLabel = UILabel()
        indexCountLabel.text = "항목 선택"
        deleteBarButton.isEnabled = false
        toolbarText.customView = indexCountLabel
        getSuccessCount()
        videoCollectionView.reloadSections(IndexSet(integer: 0))
        if videoInformationArray.count < 4{
            titleStackView.isHidden = true
        }
    }
    
    @objc func didDeleteActionSheetClicked(_ sender: UIBarButtonItem){
        let optionMenu = UIAlertController(title: "선택한 영상 삭제하기", message: "정말로 삭제하시겠어요?", preferredStyle: .actionSheet)
        
            // 2
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            self.didDeleteButtonClicked()
        }
                
            // 3
            let cancelAction = UIAlertAction(title: "취소하기", style: .cancel)
                
            // 4
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(cancelAction)
                
            // 5
            self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func didSelectAllButtonClicked(_ sender: UIBarButtonItem){
        if videoInformationArray.count != 0{
            for i in 0...videoInformationArray.count-1{
                let indexPath = IndexPath(item: i, section: 0)
                dictionarySelectedIndexPath.updateValue(true, forKey: indexPath)
            }
            for row in 0..<self.videoCollectionView.numberOfItems(inSection: 0) {
                self.videoCollectionView.selectItem(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: [])
           }
        }
        
        
        let indexCountLabel = UILabel()
        indexCountLabel.text = (dictionarySelectedIndexPath.values.filter({$0 == true}).count) == 0 ? "항목 선택":"\(dictionarySelectedIndexPath.values.filter({$0 == true}).count)개의 비디오 선택"
        deleteBarButton.isEnabled = true
        toolbarText.customView = indexCountLabel
    }
    
    func getSuccessCount(){
        successCount = videoInformationArray.filter{$0.isSucceeded == true}.count
    }
    
}
