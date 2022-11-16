//
//  HomeViewController+CollectionView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

import UIKit

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in: UITableView) -> Int {
        return isCardView ? 1 : sortedVideoInfoData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCardView ? sortedVideoInfoData.count : sortedVideoInfoData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCardView {
            // 앨범형
            let cell = homeTableView.dequeueReusableCell(withIdentifier: HomeTableViewCardCell.identifier) as! HomeTableViewCardCell
            
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
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            // 목록형
            let cell = homeTableView.dequeueReusableCell(withIdentifier: HomeTableViewListCell.identifier, for: indexPath) as! HomeTableViewListCell
            
            cell.setUpData(visitedDate: sortedVideoInfoData[indexPath.section][indexPath.row].gymVisitDate.timeToString(),
                           visitedGymName: sortedVideoInfoData[indexPath.section][indexPath.row].gymName,
                           level: "V\(sortedVideoInfoData[indexPath.section][indexPath.row].problemLevel)",
                           PF: sortedVideoInfoData[indexPath.section][indexPath.row].isSucceeded ? "성공" : "실패",
                           thumbnail: sortedVideoInfoData[indexPath.section][indexPath.row].videoLocalIdentifier!.generateCardViewThumbnail(targetSize: CGSize(width: 825, height: 825))!)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewHeader.identifier) as! HomeTableViewHeader
        
        let primaryTitleText: String = sortOption == .gymVisitDate ? sortedVideoInfoData[section][0].gymVisitDate.timeToString() : sortedVideoInfoData[section][0].gymName
        let secondaryTitleText: String = sortOption == .gymVisitDate ? sortedVideoInfoData[section][0].gymName : "\(min(sortedVideoInfoData[section].first!.gymVisitDate, sortedVideoInfoData[section].last!.gymVisitDate).timeToString()) ~  \(max(sortedVideoInfoData[section].first!.gymVisitDate, sortedVideoInfoData[section].last!.gymVisitDate).timeToString())"
        
        header.setUpData(primaryTitle: primaryTitleText,
                         secondaryTitle: secondaryTitleText)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return isCardView ? 0 : 65
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewFooter.identifier) as! HomeTableViewFooter
        footer.setUpLayout()
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isCardView ? 0 : CGFloat(OrrPadding.padding3.rawValue)
    }
}

extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isCardView {
            let vc = VideoDetailViewController()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = view.bounds.width - 2 * CGFloat(OrrPadding.padding3.rawValue)
        let height = isCardView ? (sortedVideoInfoData[indexPath.row].count > 5 ? width / 1.33 : width / 1.80) + CGFloat(OrrPadding.padding3.rawValue) : 96
        
        return CGFloat(height)
    }
}

//extension HomeViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                             withReuseIdentifier: HomeCollectionViewHeaderCell.identifier,
//                                                                             for: indexPath) as! HomeCollectionViewHeaderCell
//
//            var successCount = 0
//            flattenSortedVideoInfoData.forEach { video in
//                successCount += video.isSucceeded ? 1 : 0
//            }
//
//            headerCell.isCardView = self.isCardView
//            headerCell.setUpData(videoCount: flattenSortedVideoInfoData.count, successCount: successCount)
//
//            return headerCell
//
//        } else if kind == UICollectionView.elementKindSectionFooter {
//            let footerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                             withReuseIdentifier: HomeCollectionViewFooterCell.identifier,
//                                                                             for: indexPath) as! HomeCollectionViewFooterCell
//            footerCell.isCardView = self.isCardView
//            return footerCell
//
//        } else {
//            return UICollectionReusableView()
//        }
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        // 카드 간 간격 16 지정 / 리스트 셀 간 간격 0 지정
//        return isCardView ? CGFloat(OrrPadding.padding3.rawValue) : 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        // 앨범형, 목록형의 Header Cell의 높이를 별도로 지정
//        return CGSize(width: collectionView.frame.width, height: isCardView ? 72 : 72 + CGFloat(OrrPadding.padding7.rawValue - OrrPadding.padding3.rawValue))
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        // 앨범형, 목록형의 Footer Cell의 높이를 별도로 지정
//        return CGSize(width: collectionView.frame.width, height: CGFloat(OrrPadding.padding7.rawValue))
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = view.bounds.width - 2 * CGFloat(OrrPadding.padding3.rawValue)
//        let height = isCardView ? (sortedVideoInfoData[indexPath.row].count > 5 ? width / 1.33 : width / 1.80) : 70
//
//
//        return CGSize(width: Double(width), height: Double(height))
//    }
//}
