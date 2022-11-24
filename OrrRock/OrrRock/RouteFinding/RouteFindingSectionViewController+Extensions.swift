//
//  RouteFindingSectionViewController+Extensions.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/25.
//

import UIKit
import SnapKit

extension RouteFindingSectionViewController : UICollectionViewDelegate{
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RouteFindingCollectionViewHeaderCell.id,
                for: indexPath
            ) as! RouteFindingCollectionViewHeaderCell
            supplementaryView.prepare(title: "13개의 도전", subtitle: "편집")
            return supplementaryView
            
        case UICollectionView.elementKindSectionFooter:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RouteFindingCollectionViewHeaderCell.id,
                for: indexPath
            ) as! RouteFindingCollectionViewHeaderCell
            supplementaryView.prepare(title: "13개의 도전", subtitle: "편집")
            return supplementaryView
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension RouteFindingSectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteFindingCollectionViewCustomCell", for: indexPath) as! RouteFindingCollectionViewCustomCell
        cell.cellLevelLabel.text = "V5"
        cell.cellChallengeLabel.text = "도전 완료"
        cell.cellDateLabel.text = "2022년 10월 13일"
        cell.cellTitleLabel.text = "아띠 클라이밍장"
        cell.cellImage.image = UIImage(named: "OnboardingImage1")
        return cell
    }
}


extension RouteFindingSectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 6.5
        return CGSize(width: width, height: width * 1.8)
    }
}
