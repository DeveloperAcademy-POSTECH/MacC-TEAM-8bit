//
//  HomeViewController+CollectionView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isCardView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCardCell", for: indexPath) as! HomeCollectionViewCardCell
            
            var successCount: Int = 0
            var thumbnails: [UIImage] = []
            
            let primaryTitle: String = sortOption == .gymVisitDate ? sortedVideoInfoData[indexPath.row][0].gymVisitDate.timeToString() : sortedVideoInfoData[indexPath.row][0].gymName
            
            let secondaryTitle: String = sortOption == .gymVisitDate ? sortedVideoInfoData[indexPath.row][0].gymName : "\(min(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate).timeToString()) ~  \(max(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate).timeToString())"
            
            
            sortedVideoInfoData[indexPath.row].forEach { videoInfo in
                successCount += videoInfo.isSucceeded ? 1 : 0
                
                if let thumbnail = videoInfo.videoLocalIdentifier!.generateCardViewThumbnail(
                    targetSize: CGSize(width: cell.bounds.width, height: cell.bounds.height))
                {
                    thumbnails.append(thumbnail)
                }
            }
            
            cell.setUpData(primaryTitle: primaryTitle,
                           secondaryTitle: secondaryTitle,
                           PFCountDescription: "\(successCount)번의 성공, \(sortedVideoInfoData[indexPath.row].count - successCount)번의 실패",
                           videoCountDescription: "\(sortedVideoInfoData[indexPath.row].count)개의 비디오",
                           thumbnails: thumbnails,
                           sortOption: sortOption
            )
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewListCell", for: indexPath) as! HomeCollectionViewListCell
            
            cell.setUpData(visitedDate: flattenSortedVideoInfoData[indexPath.row].gymVisitDate.timeToString(),
                           visitedGymName: flattenSortedVideoInfoData[indexPath.row].gymName,
                           level: "V\(flattenSortedVideoInfoData[indexPath.row].problemLevel)",
                           PF: flattenSortedVideoInfoData[indexPath.row].isSucceeded ? "성공" : "실패",
                           thumbnail: flattenSortedVideoInfoData[indexPath.row].videoLocalIdentifier!.generateCardViewThumbnail(targetSize: CGSize(width: 825, height: 825))!)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isCardView{
            let vc = VideoDetailViewController()
            // 꼬마가 VideoInformation 및 기타 데이터를 받고 넘길 곳
            vc.videoInformation = flattenSortedVideoInfoData[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = VideoCollectionViewController()
            let sectionData: SectionData = SectionData(orderOption: self.orderOption,
                                                       sortOption: self.sortOption,
                                                       filterOption: self.filterOption,
                                                       gymName: sortedVideoInfoData[indexPath.row][0].gymName,
                                                       primaryGymVisitDate: sortOption == .gymVisitDate ? sortedVideoInfoData[indexPath.row][0].gymVisitDate : min(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate),
                                                       secondaryGymVisitDate: sortOption == .gymVisitDate ? nil : max(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate))
            vc.videoInformationArray = sortedVideoInfoData[indexPath.row]
            vc.sectionData = sectionData
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: HomeCollectionViewHeaderCell.identifier,
                                                                             for: indexPath) as! HomeCollectionViewHeaderCell
            
            var successCount = 0
            flattenSortedVideoInfoData.forEach { video in
                successCount += video.isSucceeded ? 1 : 0
            }
            
            headerCell.isCardView = self.isCardView
            headerCell.setUpData(videoCount: flattenSortedVideoInfoData.count, successCount: successCount)
            
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
        return isCardView ? CGFloat(OrrPadding.padding3.rawValue) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 앨범형, 목록형의 Header Cell의 높이를 별도로 지정
        return CGSize(width: collectionView.frame.width, height: isCardView ? 72 : 72 + CGFloat(OrrPadding.padding7.rawValue - OrrPadding.padding3.rawValue))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // 앨범형, 목록형의 Footer Cell의 높이를 별도로 지정
        return CGSize(width: collectionView.frame.width, height: CGFloat(OrrPadding.padding7.rawValue))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = view.bounds.width - 2 * CGFloat(OrrPadding.padding3.rawValue)
        let height = isCardView ? (sortedVideoInfoData[indexPath.row].count > 5 ? width / 1.33 : width / 1.80) : 70
        
        
        return CGSize(width: Double(width), height: Double(height))
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCardView ? sortedVideoInfoData.count : flattenSortedVideoInfoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCardView {
            let cell = homeTableView.dequeueReusableCell(withReuseIdentifier: "homeTableViewCardCell", for: indexPath) as! HomeTableViewCardCell
            
            var successCount: Int = 0
            var thumbnails: [UIImage] = []
            
            let primaryTitle: String = sortOption == .gymVisitDate ? sortedVideoInfoData[indexPath.row][0].gymVisitDate.timeToString() : sortedVideoInfoData[indexPath.row][0].gymName
            
            let secondaryTitle: String = sortOption == .gymVisitDate ? sortedVideoInfoData[indexPath.row][0].gymName : "\(min(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate).timeToString()) ~  \(max(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate).timeToString())"
            
            
            sortedVideoInfoData[indexPath.row].forEach { videoInfo in
                successCount += videoInfo.isSucceeded ? 1 : 0
                
                if let thumbnail = videoInfo.videoLocalIdentifier!.generateCardViewThumbnail(targetSize: CGSize(width: cell.bounds.width, height: cell.bounds.height)) {
                    thumbnails.append(thumbnail)
                }
            }
            
            cell.setUpData(primaryTitle: primaryTitle,
                           secondaryTitle: secondaryTitle,
                           PFCountDescription: "\(successCount)번의 성공, \(sortedVideoInfoData[indexPath.row].count - successCount)번의 실패",
                           videoCountDescription: "\(sortedVideoInfoData[indexPath.row].count)개의 비디오",
                           thumbnails: thumbnails,
                           sortOption: sortOption
            )
            
            cell.detailButton.tag = indexPath.row
            cell.detailButton.gymName = sortedVideoInfoData[indexPath.row][0].gymName
            cell.detailButton.primaryGymVisitDate = sortOption == .gymVisitDate ? sortedVideoInfoData[indexPath.row][0].gymVisitDate : min(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate)
            cell.detailButton.secondaryGymVisitDate = sortOption == .gymVisitDate ? nil : max(sortedVideoInfoData[indexPath.row].first!.gymVisitDate, sortedVideoInfoData[indexPath.row].last!.gymVisitDate)
            cell.detailButton.videoInformationArray = sortedVideoInfoData[indexPath.row]
            
            
            cell.detailButton.addTarget(self, action:  #selector(navigateToVideoCollectionView(sender:)), for: .touchUpInside)
            
            return cell
            
        } else {
            let cell = homeTableView.dequeueReusableCell(withReuseIdentifier: "homeTableViewListCell", for: indexPath) as! HomeTableViewListCell
            
            cell.setUpData(visitedDate: flattenSortedVideoInfoData[indexPath.row].gymVisitDate.timeToString(),
                           visitedGymName: flattenSortedVideoInfoData[indexPath.row].gymName,
                           level: "V\(flattenSortedVideoInfoData[indexPath.row].problemLevel)",
                           PF: flattenSortedVideoInfoData[indexPath.row].isSucceeded ? "성공" : "실패",
                           thumbnail: flattenSortedVideoInfoData[indexPath.row].videoLocalIdentifier!.generateCardViewThumbnail(targetSize: CGSize(width: 825, height: 825))!)
            
            return cell
        }
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        
    }
}
