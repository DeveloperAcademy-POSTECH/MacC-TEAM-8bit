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
    
    
    let sectionData: SectionData = SectionData(orderOption: .descend, sortOption: .gymName, filterOption: .all, gymName: "1암장", gymVisitDate: Date())
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
        let data = DataManager.shared.sortRepository(filterOption: .all, sortOption: .gymName, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func gymDOWNSort () {
        let data = DataManager.shared.sortRepository(filterOption: .all, sortOption: .gymName, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateUPSort () {
        let data = DataManager.shared.sortRepository(filterOption: .all, sortOption: .gymVisitDate, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateDOWNSort () {
        let data = DataManager.shared.sortRepository(filterOption: .all, sortOption: .gymVisitDate, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    // MARK: FILTER N SORT
    @objc func gymUPFavSort () {
        let data = DataManager.shared.sortRepository(filterOption: .favorite, sortOption: .gymName, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func gymDOWNFavSort () {
        let data = DataManager.shared.sortRepository(filterOption: .favorite, sortOption: .gymName, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateUPFavSort () {
        let data = DataManager.shared.sortRepository(filterOption: .favorite, sortOption: .gymVisitDate, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateDOWNFavSort () {
        let data = DataManager.shared.sortRepository(filterOption: .favorite, sortOption: .gymVisitDate, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func gymUPSuccessSort () {
        let data = DataManager.shared.sortRepository(filterOption: .success, sortOption: .gymName, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
        
    }
    
    @objc func gymDOWNSuccessSort () {
        let data = DataManager.shared.sortRepository(filterOption: .success, sortOption: .gymName, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateUPSuccessSort () {
        let data = DataManager.shared.sortRepository(filterOption: .success, sortOption: .gymVisitDate, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateDOWNSuccessSort () {
        let data = DataManager.shared.sortRepository(filterOption: .success, sortOption: .gymVisitDate, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func gymUPFailureSort () {
        let data = DataManager.shared.sortRepository(filterOption: .failure, sortOption: .gymName, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func gymDOWNFailureSort () {
        let data = DataManager.shared.sortRepository(filterOption: .failure, sortOption: .gymName, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateUPFailureSort () {
        let data = DataManager.shared.sortRepository(filterOption: .failure, sortOption: .gymVisitDate, orderOption: .ascend)
        print2ndDemensionData(videoInformation: data)
    }
    
    @objc func dateDOWNFailureSort () {
        let data = DataManager.shared.sortRepository(filterOption: .failure, sortOption: .gymVisitDate, orderOption: .descend)
        print2ndDemensionData(videoInformation: data)
    }
    
    func coreDataRandomvideoInformationGenerate(howMany: Int) {
        
        DataManager.shared.deleteAllData()
        
        for _ in 0..<howMany {
            let randomIndex = Int.random(in: 0..<nameList.count)
            let name = nameList[randomIndex]
            let date = Date.random(in: Date(timeIntervalSince1970: 0)..<Date(timeIntervalSince1970: 2000000))
            let url = url
            let level = probLevelList[Int.random(in: 0..<probLevelList.count)]
            let isSucceeded = tf[Int.random(in: 0..<tf.count)]
            let isFavorite = tf[Int.random(in: 0..<tf.count)]
            
            let info = VideoInfo(gymName: name, gymVisitDate: date, videoLocalIdentifier: url, problemLevel: level, isSucceeded: isSucceeded)
            
            DataManager.shared.createData(info: info)
            
        }

    }
    
    func print2ndDemensionData(videoInformation: [[VideoInformation]]) {
        print("-----PRINT DATA-----")
        for information in videoInformation {
            DataManager.shared.printDataList(info: information, primarySortOption: sectionData.sortOption)
        }
        print("--------------------")
    }

}
