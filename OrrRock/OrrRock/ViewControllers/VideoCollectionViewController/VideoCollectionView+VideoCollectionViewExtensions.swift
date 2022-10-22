//
//  VideoCollectionView+VideoCollectionViewExtensions.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/21.
//

import UIKit
import SnapKit

extension VideoCollectionViewController :  UICollectionViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !checkFirstContentOffset{
            firstContentOffset = Float(scrollView.contentOffset.y)
            checkFirstContentOffset = true
        }

        if (firstContentOffset + 64.0) < Float(scrollView.contentOffset.y){
            titleStackView.isHidden = false
        }
        else{
            titleStackView.isHidden = true
        }
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode{
        case .view:
            videoCollectionView.deselectItem(at: indexPath, animated: true)
            print("상세재생뷰로 이동")
            
        case .select:
            dictionarySelectedIndecPath[indexPath] = true
            let indexCountLabel = UILabel()
            indexCountLabel.text = (dictionarySelectedIndecPath.values.filter({$0 == true}).count) == 0 ? "항목 선택":"\(dictionarySelectedIndecPath.values.filter({$0 == true}).count)개의 비디오 선택"
            toolbarText.customView = indexCountLabel
            deleteBarButton.isEnabled = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(01111)
        if mMode == .select{
            dictionarySelectedIndecPath[indexPath] = false
            print(indexPath)
            collectionView.cellForItem(at: indexPath)?.isHighlighted = false
            collectionView.cellForItem(at: indexPath)?.isSelected = false
            let indexCountLabel = UILabel()
            indexCountLabel.text = (dictionarySelectedIndecPath.values.filter({$0 == true}).count) == 0 ? "항목 선택":"\(dictionarySelectedIndecPath.values.filter({$0 == true}).count)개의 비디오 선택"
            deleteBarButton.isEnabled = (dictionarySelectedIndecPath.values.filter({$0 == true}).count) == 0 ? false : true
            toolbarText.customView = indexCountLabel
        }
    }
    
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
            supplementaryView.prepare(title: "supplementaryView(footer)",count: imageArr.count,successCount: 40,failCount: 26)
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
        if indexPath.item % 5 == 0 {
            cell.cellLabel.backgroundColor = .blue
            cell.heartImage.alpha = 0.0
        }
        else if indexPath.item % 5 == 1{
            cell.cellLabel.backgroundColor = .yellow
            cell.heartImage.alpha = 1.0
        }
        else if indexPath.item % 5 == 2{
            cell.cellLabel.backgroundColor = .red
            cell.heartImage.alpha = 1.0
        }
        else if indexPath.item % 5 == 3{
            cell.cellLabel.backgroundColor = .black
            cell.heartImage.alpha = 1.0
        }
        else if indexPath.item % 5 == 4{
            cell.cellLabel.backgroundColor = .purple
            cell.heartImage.alpha = 1.0
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
