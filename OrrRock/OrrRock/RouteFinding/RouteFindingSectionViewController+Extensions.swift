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
            supplementaryView.prepare(title: "\(infoArr.count)개의 도전", subtitle: "편집")
            supplementaryView.delegate = self
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
        // 실사들어오면 사용할 것들
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteFindingCollectionViewCustomCell", for: indexPath) as! RouteFindingCollectionViewCustomCell
        cell.cellLevelLabel.text = "V5"
        cell.cellChallengeLabel.text = "도전 완료"
        cell.cellDateLabel.text = "2022년 10월 13일"
        cell.cellTitleLabel.text = "아띠 클라이밍장"
        cell.cellImage.image = UIImage(named: "SwipeOnboardingImage1")
        cell.isSelectable = mMode == .select ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode{
        case .view:
            routeFindingCollectionView.deselectItem(at: indexPath, animated: true)
            //화면이동 로직 들어갈 부분
            print("화면이동합니다~")
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
            //toolbar enable 들어갈 부분
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select{
            dictionarySelectedIndexPath[indexPath] = false
            collectionView.cellForItem(at: indexPath)?.isHighlighted = false
            collectionView.cellForItem(at: indexPath)?.isSelected = false
        }
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

extension RouteFindingSectionViewController : RouteFindingCollectionViewHeaderCellDelegate{
    func touchEditButton() {
        mMode = mMode == .view ? .select : .view
        routeFindingCollectionView.reloadSections(IndexSet(integer: 0))
        (routeFindingCollectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as! RouteFindingCollectionViewHeaderCell).subTitleButton.setTitle(mMode == .select ? "완료" : "편집", for: .normal)
        (routeFindingCollectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as!
        RouteFindingCollectionViewHeaderCell).subTitleButton.setTitleColor(mMode == .select ? UIColor.orrUPBlue: UIColor.orrGray400, for: .normal)

       
            self.tabBarController?.tabBar.isHidden = self.mMode == .select ? true : false
            self.bottomOptionView.layer.opacity = self.mMode == .select ? 1.0 : 0.0
        
        
    }
    
}
