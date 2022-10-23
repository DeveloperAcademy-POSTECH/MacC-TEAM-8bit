//
//  SortTestViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/22.
//

import UIKit
import SnapKit

class SortTestViewController: UIViewController {

    let nameList = ["1암장", "2암장", "3암장", "4암장", "5암장"]
    let dateList = [1, 2, 3, 4, 5]
    let url = "URL"
    let probLevelList = [0, 1, 2, 3, 4, 5]
    let tf = [true, false]
    
    let fontSize: CGFloat = 10
    let margin: CGFloat = 10
    let widthNHeight: CGFloat = 75
    
    let sortButtonText = ["암장이름 오름차순", "암장이름 내림차순", "방문날짜 최근순", "방문날짜 오래된순"]
    let sortButtons: [UIButton] = [UIButton(), UIButton(), UIButton(), UIButton()]
    
    let sortNFilterButtonText = ["암장 이름\n오름차순\nFAV", "암장 이름\n내림차순\nFAV", "암장 날짜\n최근순\nFAV", "암장 날짜\n오래된순\nFAV", "암장 이름\n오름차순\nPASS", "암장 이름\n내림차순\nPASS", "암장 날짜\n최근순\nPASS", "암장 날짜\n오래된순\nPASS", "암장 이름\n오름차순\nFAIL", "암장 이름\n내림차순\nFAIL", "암장 날짜\n최근순\nFAIL", "암장 날짜\n오래된순\nFAIL"]
    let sortNFilterButtons: [UIButton] = [UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataRandomvideoInformationGenerate(howMany: 30)
        
        
        // 암장별, 방문일자별로만 데이터를 확인하고 싶다면 아래의 주석 해제 후 line 39,40을 주석처리 후 실행해주세요
        //layoutConfigureForSortButtons()
        //sortButtonComponentConfigure()
        
        layoutConfigureForSortNFilterButtons()
        sortNFilterButtonComponentConfigure()
    }
    
    func layoutConfigureForSortButtons() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        for index in 0..<sortButtons.count {
            view.addSubview(sortButtons[index])
            sortButtons[index].backgroundColor = . yellow
            sortButtons[index].titleLabel?.font = .systemFont(ofSize: fontSize)
            sortButtons[index].setTitle(sortButtonText[index], for: .normal)
            sortButtons[index].setTitleColor(.black, for: .normal)
            
            if index != 0 {
                sortButtons[index].snp.makeConstraints({
                    $0.top.equalTo(sortButtons[index-1].snp.bottom).offset(margin)
                    $0.centerX.equalToSuperview()
                    $0.width.height.equalTo(widthNHeight)
                })
            } else {
                sortButtons[index].snp.makeConstraints({
                    $0.top.equalTo(safeArea).offset(margin)
                    $0.centerX.equalToSuperview()
                    $0.width.height.equalTo(widthNHeight)
                })
            }
        }
    }
                                               
    func sortButtonComponentConfigure() {
        
        sortButtons[0].addTarget(self, action: #selector(gymUPSort), for: .touchUpInside)
        sortButtons[1].addTarget(self, action: #selector(gymDOWNSort), for: .touchUpInside)
        sortButtons[2].addTarget(self, action: #selector(dateUPSort), for: .touchUpInside)
        sortButtons[3].addTarget(self, action: #selector(dateDOWNSort), for: .touchUpInside)
        
    }
    
    
    func layoutConfigureForSortNFilterButtons() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        for index in 0..<sortNFilterButtons.count {
            view.addSubview(sortNFilterButtons[index])
            sortNFilterButtons[index].backgroundColor = . yellow
            sortNFilterButtons[index].titleLabel?.font = .systemFont(ofSize: fontSize)
            sortNFilterButtons[index].setTitle(sortNFilterButtonText[index], for: .normal)
            sortNFilterButtons[index].setTitleColor(.black, for: .normal)
            sortNFilterButtons[index].titleLabel?.numberOfLines = 3
            
            if index == 0 {
                sortNFilterButtons[index].snp.makeConstraints({
                    $0.top.equalTo(safeArea.snp.top).offset(margin)
                    $0.leading.equalTo(safeArea.snp.leading).inset(margin)
                    $0.width.height.equalTo(widthNHeight)
                })
            }
            else if index < 4 {
                sortNFilterButtons[index].snp.makeConstraints({
                    $0.top.equalTo(sortNFilterButtons[index-1].snp.bottom).offset(margin)
                    $0.leading.equalTo(safeArea.snp.leading).inset(margin)
                    $0.width.height.equalTo(widthNHeight)
                })
            } else if index == 4 {
                sortNFilterButtons[index].snp.makeConstraints({
                    $0.top.equalTo(safeArea.snp.top).offset(margin)
                    $0.centerX.equalToSuperview()
                    $0.width.height.equalTo(widthNHeight)
                })
            } else if index < 8 {
                sortNFilterButtons[index].snp.makeConstraints({
                    $0.top.equalTo(sortNFilterButtons[index-1].snp.bottom).offset(margin)
                    $0.centerX.equalToSuperview()
                    $0.width.height.equalTo(widthNHeight)
                })
            } else if index == 8 {
                sortNFilterButtons[index].snp.makeConstraints({
                    $0.top.equalTo(safeArea.snp.top).offset(margin)
                    $0.trailing.equalTo(safeArea.snp.trailing).inset(margin)
                    $0.width.height.equalTo(widthNHeight)
                })
            } else {
                sortNFilterButtons[index].snp.makeConstraints({
                    $0.top.equalTo(sortNFilterButtons[index-1].snp.bottom).offset(margin)
                    $0.trailing.equalTo(safeArea.snp.trailing).inset(margin)
                    $0.width.height.equalTo(widthNHeight)
                })
            }
        }
    }
    
    func sortNFilterButtonComponentConfigure() {
        sortNFilterButtons[0].addTarget(self, action: #selector(gymUPFavSort), for: .touchUpInside)
        sortNFilterButtons[1].addTarget(self, action: #selector(gymDOWNFavSort), for: .touchUpInside)
        sortNFilterButtons[2].addTarget(self, action: #selector(dateUPFavSort), for: .touchUpInside)
        sortNFilterButtons[3].addTarget(self, action: #selector(dateDOWNFavSort), for: .touchUpInside)
        sortNFilterButtons[4].addTarget(self, action: #selector(gymUPSuccessSort), for: .touchUpInside)
        sortNFilterButtons[5].addTarget(self, action: #selector(gymDOWNSuccessSort), for: .touchUpInside)
        sortNFilterButtons[6].addTarget(self, action: #selector(dateUPSuccessSort), for: .touchUpInside)
        sortNFilterButtons[7].addTarget(self, action: #selector(dateDOWNSuccessSort), for: .touchUpInside)
        sortNFilterButtons[8].addTarget(self, action: #selector(gymUPFailureSort), for: .touchUpInside)
        sortNFilterButtons[9].addTarget(self, action: #selector(gymDOWNFailureSort), for: .touchUpInside)
        sortNFilterButtons[10].addTarget(self, action: #selector(dateUPFailureSort), for: .touchUpInside)
        sortNFilterButtons[11].addTarget(self, action: #selector(dateDOWNFailureSort), for: .touchUpInside)
        
    }
    
    // MARK: NORMAL SORT ONLY
    @objc func gymUPSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .all, sortOption: .gymName)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
    }
    
    @objc func gymDOWNSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .all, sortOption: .gymName)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
        
    }
    
    @objc func dateUPSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .all, sortOption: .gymVisitDate)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    @objc func dateDOWNSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .all, sortOption: .gymVisitDate)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    // MARK: FILTER N SORT
    @objc func gymUPFavSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .favorite, sortOption: .gymName)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
    }
    
    @objc func gymDOWNFavSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .favorite, sortOption: .gymName)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
    }
    
    @objc func dateUPFavSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .favorite, sortOption: .gymVisitDate)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    @objc func dateDOWNFavSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .favorite, sortOption: .gymVisitDate)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    @objc func gymUPSuccessSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .success, sortOption: .gymName)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
        
    }
    
    @objc func gymDOWNSuccessSort () {
       // CoreDataManager.shared.sortVideoInformation(filterOption: .success, sortOption: .gymName)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
    }
    
    @objc func dateUPSuccessSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .success, sortOption: .gymVisitDate)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    @objc func dateDOWNSuccessSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .success, sortOption: .gymVisitDate)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    @objc func gymUPFailureSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .failure, sortOption: .gymName)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
    }
    
    @objc func gymDOWNFailureSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .failure, sortOption: .gymName)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymName)
    }
    
    @objc func dateUPFailureSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .failure, sortOption: .gymVisitDate)
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    @objc func dateDOWNFailureSort () {
        CoreDataManager.shared.sortVideoInformation(filterOption: .failure, sortOption: .gymVisitDate)
        CoreDataManager.shared.reverseSort()
        CoreDataManager.shared.printAllSortedData(primarySortOption: .gymVisitDate)
    }
    
    func coreDataRandomvideoInformationGenerate(howMany: Int) {
        
        CoreDataManager.shared.deleteAllData()
        
        for _ in 0..<howMany {
            let randomIndex = Int.random(in: 0..<nameList.count)
            let name = nameList[randomIndex]
            let date = Date.random(in: Date(timeIntervalSince1970: 0)..<Date(timeIntervalSince1970: 2000000))
            let url = url
            let level = probLevelList[Int.random(in: 0..<probLevelList.count)]
            let isSucceeded = tf[Int.random(in: 0..<tf.count)]
            let isFavorite = tf[Int.random(in: 0..<tf.count)]
            
            let info = VideoInfo(gymName: name, gymVisitDate: date, videoUrl: url, problemLevel: level, isSucceeded: isSucceeded)
            
            CoreDataManager.shared.createData(info: info)
            
        }
        
        print("랜덤 데이터 \(CoreDataManager.shared.readData().count)개가 Core Data에 저장되었습니다.")
//        CoreDataManager.shared.fetchData()
        CoreDataManager.shared.reloadRawVideoInformation()
        CoreDataManager.shared.printRawData(standard: .gymName)
    }

}
