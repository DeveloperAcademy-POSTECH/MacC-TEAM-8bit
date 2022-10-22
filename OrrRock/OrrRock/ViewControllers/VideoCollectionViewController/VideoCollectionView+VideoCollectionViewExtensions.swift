//
//  VideoCollectionView+VideoCollectionViewExtensions.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/21.
//

import UIKit
import SnapKit

extension VideoCollectionViewController :  UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: VideoCollectionViewHeaderCell.id,
                for: indexPath
            ) as! VideoCollectionViewHeaderCell
            supplementaryView.prepare(title: "supplementaryView(header)")
            return supplementaryView
            
        case UICollectionView.elementKindSectionFooter:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: VideoCollectionFooterCell.id + "footer",
                for: indexPath
            ) as! VideoCollectionFooterCell
            supplementaryView.prepare(title: "supplementaryView(footer)",count: imageArr.count,successCount: 40,failCount: 24)
            return supplementaryView
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension VideoCollectionViewController  : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customVideoCollectionCell", for: indexPath) as! VideoCollectionViewCell
        cell.cellImage.image = UIImage(named: imageArr[indexPath.row])
        if indexPath.row % 5 == 0 {
            cell.cellLabel.backgroundColor = .blue
            cell.heartImage.alpha = 0.0
        }
        else if indexPath.row % 5 == 1{
            cell.cellLabel.backgroundColor = .yellow
        }
        else if indexPath.row % 5 == 2{
            cell.cellLabel.backgroundColor = .red
        }
        else if indexPath.row % 5 == 3{
            cell.cellLabel.backgroundColor = .black
        }
        else if indexPath.row % 5 == 4{
            cell.cellLabel.backgroundColor = .purple
        }
        else{
            
        }
        return cell
    }
}

extension VideoCollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width * 2.13)
    }
}
