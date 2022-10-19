//
//  HomeCollectionViewCardCell+Extensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// 디버깅을 위해 생성하는 CollectionViewCell의 개수를 10으로 고정해두었음.
//      받아온 영상의 개수가 0개~10개까지는 해당 개수를 return.
//      영상의 개수가 10개가 넘을 때에는 10을 return 하도록 작성 필요.

import UIKit

extension HomeCollectionViewCardCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCardCollectionViewThumbnailCell", for: indexPath) as! HomeCardCollectionViewThumbnailCell
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
