//
//  RouteFindingFifthOnboardingViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/27.
//

import UIKit

class RouteFindingFifthOnboardingViewController: RouteFindingOnboardingParentViewController {
    
    // MARK: Variables
    var pages: [PageInfo] = [PageInfo(rowOrder: 0)]
    var pageViews: [UIView] = [UIView()]
    var centerCell: RouteFindingThumbnailCollectionViewCell?
    
    // MARK: View Components
    
    override var descriptionView: UILabel {
        get { return super.descriptionView }
        set { self.descriptionView = newValue }
    }
    
    let thumbnailCollectionView: UICollectionView = {
        let layout = RouteFindingThumbnailCollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(RouteFindingThumbnailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: RouteFindingThumbnailCollectionViewCell.identifier)
        collection.register(RouteFindingThumbnailCollectionViewAddCell.classForCoder(), forCellWithReuseIdentifier: RouteFindingThumbnailCollectionViewAddCell.identifier)
        
        return collection
    }()
    
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpThumbnailCollectionViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpThumbnailCollectionViewScrollInset()
        descriptionView.text = "+를 눌러\n다음 동작을 기록할 수 있는 페이지를 추가할 수 있어요"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpThumbnailCollectionViewScroll()
    }
    
    
    // MARK: Functions
    
    // MARK: @objc Functions
    
}

    

extension RouteFindingFifthOnboardingViewController {
    
    // MARK: Set Up Functions
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            $0.height.equalTo(74)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setUpThumbnailCollectionViewDelegate() {
        thumbnailCollectionView.dataSource = self
        thumbnailCollectionView.delegate = self
    }
    
    func setUpThumbnailCollectionViewScrollInset() {
        // CollectionView가 다 그려지고 난 뒤, CollectionView의 content에 Inset을 넣어 끝까지 스크롤이 가능하도록 하기
        let layoutMargins: CGFloat = self.thumbnailCollectionView.layoutMargins.left
        let sideInset = self.view.frame.width / 2 - layoutMargins
        self.thumbnailCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    func setUpThumbnailCollectionViewScroll() {
        // 뷰가 올라오면 가장 처음 페이지로 이동
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension RouteFindingFifthOnboardingViewController: RouteFindingThumbnailCollectionViewAddCellDelegate {
    // 페이지 추가 버튼이 눌리면 새로운 페이지를 추가
    func tapAddPageButton() {
        pages.append(PageInfo(rowOrder: pages.last!.rowOrder + 1))
        let newView = UIView()
        self.backgroundImageView.addSubview(newView)
        pageViews.append(newView)
        
        thumbnailCollectionView.reloadData()
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: pageViews.count, section: 0), at: .centeredHorizontally, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.triggerMoveToNextPage()
        }
    }
}

extension RouteFindingFifthOnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 페이지 개수 + 페이지 추가 버튼
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 페이지에 대한 섬네일 생성
        if indexPath.row != pages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteFindingThumbnailCollectionViewCell.identifier, for: indexPath) as! RouteFindingThumbnailCollectionViewCell
            cell.indexPathOfCell = indexPath
            cell.pageImage.contentMode = .scaleAspectFill
            cell.pageImage.clipsToBounds = true
            cell.pageImage.image = backgroundImage
            
            return cell
        }
        // 페이지 추가 버튼 생성
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteFindingThumbnailCollectionViewAddCell.identifier, for: indexPath) as! RouteFindingThumbnailCollectionViewAddCell
            cell.delegate = self
            
            return cell
        }
    }
}

extension RouteFindingFifthOnboardingViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }

        let centerPoint = CGPoint(x: self.thumbnailCollectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: self.thumbnailCollectionView.frame.size.height / 2 + scrollView.contentOffset.y)

        // 화면 가운데에 셀의 indexPath에 대해
        if let indexPath = thumbnailCollectionView.indexPathForItem(at: centerPoint) {
            // 선택된 셀이 페이지 추가 버튼이라면
            if indexPath.row == pages.count {

            }
            // 선택된 셀이 페이지이면
            else {
                // 가운데 셀을 선택
                self.centerCell = self.thumbnailCollectionView.cellForItem(at: indexPath) as? RouteFindingThumbnailCollectionViewCell
                centerCell?.showSelectedBar()
                
                let beforeIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                let afterIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)

                if let beforeCell = (self.thumbnailCollectionView.cellForItem(at: beforeIndexPath) as? RouteFindingThumbnailCollectionViewCell) {
                    beforeCell.hideSelectedBar()
                }
                if let afterCell = (self.thumbnailCollectionView.cellForItem(at: afterIndexPath) as? RouteFindingThumbnailCollectionViewCell) {
                    afterCell.hideSelectedBar()
                }
            }
        }
    }
    
    // 썸네일 셀을 단순 터치했을 때, 해당 셀로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
