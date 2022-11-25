//
//  RouteFindingFeatureViewController+UICollectionViewExtensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/25.
//

import UIKit

extension RouteFindingFeatureViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard scrollView is UICollectionView else { return }

        let centerPoint = CGPoint(x: self.thumbnailCollectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: self.thumbnailCollectionView.frame.size.height / 2 + scrollView.contentOffset.y)

        if let indexPath = thumbnailCollectionView.indexPathForItem(at: centerPoint) {
            if indexPath.row == pages.count {

            } else {
                self.centerCell = self.thumbnailCollectionView.cellForItem(at: indexPath) as? RouteFindingThumbnailCollectionViewCell
                centerCell?.showSelectedBar()
                selectPage()

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
}

extension RouteFindingFeatureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != pages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteFindingThumbnailCollectionViewCell.identifier, for: indexPath) as! RouteFindingThumbnailCollectionViewCell
            cell.indexPathOfCell = indexPath
            cell.delegate = self
//            cell.backgroundColor = .systemRed
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteFindingThumbnailCollectionViewAddCell.identifier, for: indexPath) as! RouteFindingThumbnailCollectionViewAddCell
            cell.delegate = self
            
            return cell
        }
    }
}


