//
//  HomeCollectionViewCardCell+Extensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

import UIKit

extension HomeCollectionViewCardCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 10개의 영상이 들어오지 않더라도,  배경색을 부여한 빈 cell이 PlaceHolder로 작동할 수 있도록 return을 10으로 고정
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCardCollectionViewThumbnailCell", for: indexPath) as! HomeCardCollectionViewThumbnailCell
        cell.setData(image: videoThumbnails.count > indexPath.row ? videoThumbnails[indexPath.row] : nil)
        return cell
    }
}

extension HomeCollectionViewCardCell:  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = contentView.bounds.width / 5 - 1
        let height = width
        
        return CGSize(width: Double(width), height: Double(height))
    }
}
