//
//  HomeViewController+CollectionView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// 퀵 액션을 통해 앨범형/목록형 옵션 변환에 따른 HeaderView 높이 변경 구현 필요

import UIKit

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 디버깅을 위해 카드의 개수를 5로 지정해두었음.
        // 이후 동작 구현 시 카드 개수 지정을 위해 해당 값을 변경해주면 됨.
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCardCell", for: indexPath) as! HomeCollectionViewCardCell
        
        // 성공 개수 Count
        // Thumbnails 배열 생성 (최대 10개의 UIImage를 담는 배열)
        // CollectionViewCell에 필요한 데이터 loadCardViewData 함수를 통해 전달하기
        
        // EX)
        //        var TESTSuccessed: Int = 0
        //        var TESTthumbnails: [UIImage] = []
        //
        //        TESTCardDataList[indexPath.row].forEach {
        //            if $0.isSuccessed { TESTSuccessed += 1 }
        //            TESTthumbnails.append(UIImage(named: $0.thumbnail)!)
        //        }
        //
        //        cell.loadCardViewData(visitedDate: dateFormatter.string(from: TESTCardDataList[indexPath.row][0].gymVisitDate),
        //                              visitedGymName: TESTCardDataList[indexPath.row][0].gymName,
        //                              PFCountDescription: "\(TESTSuccessed)개의 성공, \(TESTCardDataList[indexPath.row].count - TESTSuccessed)개의 실패",
        //                              videoCountDescription: "\(TESTCardDataList[indexPath.row].count)개의 영상",
        //                              thumbnails: TESTthumbnails)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: HomeCollectionViewHeaderCell.identifier,
                                                                   for: indexPath)
        } else {
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 카드 간 간격 16 지정
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // SafeArea의 Top 부터 CollectionView의 HeaderView 높이를 계산하면 됨
        // 앨범 형 / 목록 형에 따라 HeaderView의 높이가 달라져야함
        return CGSize(width: collectionView.frame.width, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 카드 비율 가로세로 비율 1.33:1
        let width = view.bounds.width - 2 * HorizontalPaddingSize
        let height = width / 1.33
        
        return CGSize(width: Double(width), height: Double(height))
    }
}
