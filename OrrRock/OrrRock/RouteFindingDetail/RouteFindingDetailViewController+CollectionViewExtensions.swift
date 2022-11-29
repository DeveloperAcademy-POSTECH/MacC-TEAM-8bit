//
//  RouteFindingDetailViewController+CollectionViewExtensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/30.
//

import UIKit

extension RouteFindingDetailViewController: UICollectionViewDataSource {
    // 컬렉션뷰의 스크롤이 발생했을 때, 화면의 CenterX에 위치한 셀에 대한 처리를 수행
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        
        let centerPoint = CGPoint(x: self.thumbnailCollectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: self.thumbnailCollectionView.frame.size.height / 2 + scrollView.contentOffset.y)
        
        // 화면 가운데에 셀의 indexPath에 대해
        if let indexPath = thumbnailCollectionView.indexPathForItem(at: centerPoint) {
            // 가운데 셀을 선택
            self.centerCell = self.thumbnailCollectionView.cellForItem(at: indexPath) as? RouteFindingThumbnailCollectionViewCell
            centerCell?.showSelectedBar()
            showSelectedPage()
            
            // 이전, 이후 셀에 대해 선택 취소 처리를 수행
            // 아래 작업을 적용하지 않을 경우, 스크롤이 빠르게 움직일 때 셀의 selectedBar가 남아있는 경우가 발생
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
    
//    // 썸네일 셀을 단순 터치했을 때, 해당 셀로 이동
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//    }
}


extension RouteFindingDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllerListForPageVC.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteFindingThumbnailCollectionViewCell.identifier, for: indexPath) as! RouteFindingThumbnailCollectionViewCell
        cell.indexPathOfCell = indexPath
        cell.pageImage.contentMode = .scaleAspectFill
        cell.pageImage.clipsToBounds = true
        cell.pageImage.image = routeDataDraft.routeInfoForUI.imageLocalIdentifier.generateCardViewThumbnail()
//        cell.delegate = self
        
        return cell
    }
}
