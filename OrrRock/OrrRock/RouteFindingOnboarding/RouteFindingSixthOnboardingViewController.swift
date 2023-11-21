//
//  RouteFindingSixthOnboardingViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/27.
//

import UIKit

class RouteFindingSixthOnboardingViewController: RouteFindingOnboardingParentViewController {

    // MARK: Variables

    let collectionViewCellSize: Int = 62

    var isMovingToNextPage: Bool = false
    var pages: [PageInfo] = [PageInfo(rowOrder: 0), PageInfo(rowOrder: 1)]
    var pageViews: [UIView] = [UIView(), UIView()]
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
    
    // 삭제모드 진입 시 화면 인터렉션 방지를 위한 뷰
    private lazy var deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelDeleteMode))
        view.addGestureRecognizer(gestureRecognizer)
        
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        button.setImage(UIImage(systemName: "minus.circle.fill")?.resized(to: CGSize(width: 26, height: 26)).withTintColor(.orrFail!, renderingMode: .alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(deletePage(_:)), for: .touchUpInside)
        button.backgroundColor = .orrWhite
        button.layer.cornerRadius = 14
        button.tintColor = .orrFail
        return button
    }()
    
    private lazy var deleteImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.image = backgroundImage
        return view
    }()
    
    
    // MARK: Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpThumbnailCollectionViewDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpThumbnailCollectionViewScrollInset()
        descriptionView.text = "추가한 페이지는 꾸욱 눌러\n삭제할 수 있어요"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpThumbnailCollectionViewScroll()
    }
    
    // MARK: Functions
    
    // 삭제모드를 위한 뷰 띄우기
    private func showDeleteView(for indexPath: IndexPath) {
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerX.equalTo(deleteView.snp.centerX)
            $0.width.height.equalTo(28)
            $0.bottom.equalTo(thumbnailCollectionView.snp.top).offset(-20)
        }
        
        deleteView.addSubview(deleteImage)
        deleteImage.snp.makeConstraints {
            $0.center.equalTo(self.thumbnailCollectionView.cellForItem(at: indexPath)!.snp.center)
            $0.width.height.equalTo(self.thumbnailCollectionView.cellForItem(at: indexPath)!.frame.width)
        }
    }
    
    // MARK: @objc Functions
    
    @objc private func cancelDeleteMode() {
        deleteView.removeFromSuperview()
        deleteButton.removeFromSuperview()
        deleteImage.removeFromSuperview()
        UIView.animate(withDuration: 0.2) {
            self.deleteImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    // 선택된 페이지를 삭제
    @objc private func deletePage(_ sender: UIButton) {
        guard let targetPageCell = centerCell else { return }
        
        // 남은 셀의 수가 1개라면 삭제하지 않음
        // 필요 시 아래 if 블록 내에 알림 추가
        if pages.count > 1 {
            pages.remove(at: targetPageCell.indexPathOfCell.row)
            pageViews.remove(at: targetPageCell.indexPathOfCell.row)
        }
        
        thumbnailCollectionView.reloadData()
        
        let nextPath = IndexPath(row: (targetPageCell.indexPathOfCell.row > 0) ? targetPageCell.indexPathOfCell.row - 1 : 1,
                                 section: targetPageCell.indexPathOfCell.section)
        
        thumbnailCollectionView.scrollToItem(at: nextPath, at: .centeredHorizontally, animated: true)
        cancelDeleteMode()
        
        if !isMovingToNextPage {
            isMovingToNextPage = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.triggerMoveToNextPage()
            }
        }
    }
}
    


extension RouteFindingSixthOnboardingViewController {
    
    // MARK: Set Up Functions
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            $0.height.equalTo(74)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        super.setUpSkipButtonLayout()
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

extension RouteFindingSixthOnboardingViewController: RouteFindingThumbnailCollectionViewCellDelegate {
    // 셀을 long press 했을 때 삭제모드로 진입
    func enterDeletePageMode(indexPath: IndexPath) {
        thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        showDeleteView(for: indexPath)
        
        UIView.animate(withDuration: 0.2) {
            self.deleteImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
}

extension RouteFindingSixthOnboardingViewController: UICollectionViewDataSource {
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
            cell.delegate = self
            
            return cell
        }
        // 페이지 추가 버튼 생성
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteFindingThumbnailCollectionViewAddCell.identifier, for: indexPath) as! RouteFindingThumbnailCollectionViewAddCell
            
            return cell
        }
    }
}

extension RouteFindingSixthOnboardingViewController: UICollectionViewDelegate {
    
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
