//
//  HomeViewController+CollectionView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

import UIKit

extension HomeViewController: UITableViewDataSource {
    // TableView Section 개수 지정
    func numberOfSections(in: UITableView) -> Int {
        return isCardView ? 1 : sortedVideoInfoData.count
    }
    
    // TableView Section 내 셀의 개수 지정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCardView ? sortedVideoInfoData.count : sortedVideoInfoData[section].count
    }
    
    // TableView Cell의 내용 지정
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
                
                if let thumbnail = videoInfo.videoLocalIdentifier!.generateCardViewThumbnail() {
                    thumbnails.append(thumbnail)
                }
            }
            
            cell.setUpData(primaryTitle: primaryTitle,
                           secondaryTitle: secondaryTitle,
                           PFCountDescription: "\(successCount)번의 성공, \(sortedVideoInfoData[indexPath.row].count - successCount)번의 실패",
                           videoCountDescription: "\(sortedVideoInfoData[indexPath.row].count)개의 기록",
                           thumbnails: thumbnails,
                           sortOption: sortOption
            )
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            // 목록형
            let cell = homeTableView.dequeueReusableCell(withIdentifier: HomeTableViewListCell.identifier, for: indexPath) as! HomeTableViewListCell
            
            cell.setUpData(level: "V\(sortedVideoInfoData[indexPath.section][indexPath.row].problemLevel)",
                           PF: sortedVideoInfoData[indexPath.section][indexPath.row].isSucceeded ? "성공" : "실패",
                           thumbnail: sortedVideoInfoData[indexPath.section][indexPath.row].videoLocalIdentifier!.generateCardViewThumbnail(),
                           feedback: sortedVideoInfoData[indexPath.section][indexPath.row].feedback ?? "")           
            return cell
        }
    }
    
    // TableView Header 지정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewHeader.identifier) as! HomeTableViewHeader
        
        let primaryTitleText: String = sortOption == .gymVisitDate ? sortedVideoInfoData[section][0].gymVisitDate.timeToString() : sortedVideoInfoData[section][0].gymName
        let secondaryTitleText: String = sortOption == .gymVisitDate ? sortedVideoInfoData[section][0].gymName : "\(min(sortedVideoInfoData[section].first!.gymVisitDate, sortedVideoInfoData[section].last!.gymVisitDate).timeToString()) ~  \(max(sortedVideoInfoData[section].first!.gymVisitDate, sortedVideoInfoData[section].last!.gymVisitDate).timeToString())"
        
        header.setUpData(primaryTitle: primaryTitleText,
                         secondaryTitle: secondaryTitleText)
        return header
    }
    
    // TableView Header의 높이 지정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return isCardView ? 0 : 60
    }
    
    // TableView Footer 지정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableViewFooter.identifier) as! HomeTableViewFooter
        footer.setUpLayout()
        
        return footer
    }
    
    // TableView Footer의 높이 지정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isCardView ? 0 : CGFloat(OrrPd.pd16.rawValue)
    }
}

extension HomeViewController: UITableViewDelegate{
    // TableView Cell 선택 시 화면 전환 지정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isCardView {
            let vc = VideoDetailViewController()
            vc.videoInformation = sortedVideoInfoData[indexPath.section][indexPath.row]
            vc.videoInformationArray = sortedVideoInfoData[indexPath.section]
            vc.currentIndex = indexPath.row
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
    
    // TableView Cell의 높이 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = view.bounds.width - 2 * CGFloat(OrrPd.pd16.rawValue)
        let height = isCardView ? (sortedVideoInfoData[indexPath.row].count > 5 ? width / 1.33 : width / 1.80) + CGFloat(OrrPd.pd16.rawValue) : 96
        
        return CGFloat(height)
    }
}
