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
            let vc = VideoDetailViewController()
            vc.videoInformation = videoInformationArray[indexPath.item]
            vc.videoInformationArray = videoInformationArray
            vc.currentIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
            let indexCountLabel = UILabel()
            indexCountLabel.text = (dictionarySelectedIndexPath.values.filter({$0 == true}).count) == 0 ? "항목 선택":"\(dictionarySelectedIndexPath.values.filter({$0 == true}).count)개의 비디오 선택"
            toolbarText.customView = indexCountLabel
            deleteBarButton.isEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select{
            dictionarySelectedIndexPath[indexPath] = false
            collectionView.cellForItem(at: indexPath)?.isHighlighted = false
            collectionView.cellForItem(at: indexPath)?.isSelected = false
            let indexCountLabel = UILabel()
            indexCountLabel.text = (dictionarySelectedIndexPath.values.filter({$0 == true}).count) == 0 ? "항목 선택":"\(dictionarySelectedIndexPath.values.filter({$0 == true}).count)개의 비디오 선택"
            deleteBarButton.isEnabled = (dictionarySelectedIndexPath.values.filter({$0 == true}).count) == 0 ? false : true
            toolbarText.customView = indexCountLabel
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoInformationArray.count
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
            supplementaryView.prepare(title: sectionData.sortOption == .gymVisitDate ?  sectionData!.primaryGymVisitDate.timeToString() : sectionData!.gymName,subtitle: sectionData!.sortOption == .gymVisitDate ? sectionData.gymName : "\(sectionData.primaryGymVisitDate.timeToString()) ~ \(sectionData.secondaryGymVisitDate!.timeToString())")
            return supplementaryView
            
        case UICollectionView.elementKindSectionFooter:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: VideoCollectionFooterCell.id + "footer",
                for: indexPath
            ) as! VideoCollectionFooterCell
            supplementaryView.prepare(title: "supplementaryView(footer)",count: videoInformationArray.count,successCount: successCount,failCount: videoInformationArray.count - successCount)
            return supplementaryView
        default:
            return UICollectionReusableView()
        }
    }
}

extension VideoCollectionViewController  : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customVideoCollectionCell", for: indexPath) as! VideoCollectionViewCell
        
        cell.cellImage.image = videoInformationArray[indexPath.row].videoLocalIdentifier?.generateCardViewThumbnail()
        if videoInformationArray[indexPath.item].isFavorite{
            cell.heartImage.alpha = 1.0
        }
        else{
            cell.heartImage.alpha = 0.0
        }
        if videoInformationArray[indexPath.item].isSucceeded{
            cell.cellLabel.backgroundColor = .orrPass
        }
        else{
            cell.cellLabel.backgroundColor = .orrFail
        }
        cell.cellLabel.text = videoInformationArray[indexPath.item].problemLevel == -1 ? "V?" : "V\(videoInformationArray[indexPath.item].problemLevel)"
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
