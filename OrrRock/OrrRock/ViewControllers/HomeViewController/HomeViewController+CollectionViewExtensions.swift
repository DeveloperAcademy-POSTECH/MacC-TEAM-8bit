//
//  HomeViewController+CollectionView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// 퀵 액션을 통해 앨범형/목록형 옵션 변환에 따른 HeaderView 높이 변경 구현 필요
// 데이터 파싱 함수 구현 필요

import UIKit

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 디버깅을 위해 카드의 개수를 10으로 지정해두었음.
        // 이후 동작 구현 시 카드 개수 지정을 위해 해당 값을 변경해주면 됨.
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell!
        
        if isCardView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCardCell", for: indexPath) as! HomeCollectionViewCardCell
            
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewListCell", for: indexPath) as! HomeCollectionViewListCell
        }
          
        // TODO
        // 성공 개수 Count 하기
        // Thumbnails 배열 생성 (최대 10개의 UIImage를 담는 배열)
        // CollectionViewCell에 필요한 데이터 loadCardViewData 함수를 통해 전달하기
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: HomeCollectionViewHeaderCell.identifier,
                                                                             for: indexPath) as! HomeCollectionViewHeaderCell
            headerCell.isCardView = self.isCardView
            return headerCell
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: HomeCollectionViewFooterCell.identifier,
                                                                             for: indexPath) as! HomeCollectionViewFooterCell
            footerCell.isCardView = self.isCardView
            return footerCell
            
        } else {
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 카드 간 간격 16 지정 / 리스트 셀 간 간격 0 지정
        return isCardView ? 16 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 앨범형, 목록형의 Header Cell의 높이를 별도로 지정
        return CGSize(width: collectionView.frame.width, height: isCardView ? 117 : 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // 앨범형, 목록형의 Footer Cell의 높이를 별도로 지정
        return CGSize(width: collectionView.frame.width, height: isCardView ? 72 : 102)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 카드 셀의 가로세로 비율 1.33:1로 지정
        let width = view.bounds.width - 2 * HorizontalPaddingSize
        let height = isCardView ? width / 1.33 : 70
        
        return CGSize(width: Double(width), height: Double(height))
    }
}
