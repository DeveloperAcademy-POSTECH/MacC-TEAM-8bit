//
//  CRUDTestViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/10/25.
//

import UIKit

class CRUDTestViewController: UIViewController {

    var sectionData: SectionData = SectionData(orderOption: .descend, sortOption: .gymName, filterOption: .all, gymName: "5암장", gymVisitDate: Date())
    
    var currentVideoInformation: [VideoInformation] = []
    var currentGymName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
//    새로운 데이터 생성 후 테스트 시 주석 제거 & repositoryUpdate 주석
//       DataManager.shared.deleteAllData()
//       DataManager.shared.coreDataRandomvideoInformationGenerate(howMany: 30)
       
       // 기존 데이터로 테스트 시 주석 제거
        DataManager.shared.updateRepository()
        
        DataManager.shared.repository.finalSortVideoInformation(filterOption: sectionData.filterOption, sortOption: sectionData.sortOption, orderOption: sectionData.orderOption)
        
        DataManager.shared.printRawData(standard: .gymName)
        
        currentVideoInformation = DataManager.shared.repository.finalSortVideoInformation(filterOption: sectionData.filterOption, sortOption: sectionData.sortOption, orderOption: sectionData.orderOption)[0]
        
        currentGymName = currentVideoInformation[0].gymName
        
        print("BEFORE")
        
        for information in currentVideoInformation {
            printData(info: information, primarySortOption: sectionData.sortOption)
        }
        
//        caseUPDATE()
        caseDELETE()
        
        currentVideoInformation = sortVideoInformation(videoInformation: currentVideoInformation, sectionData: sectionData)
        
        print(currentVideoInformation.count)
        
        print("AFTER")
        
        for information in currentVideoInformation {
            printData(info: information, primarySortOption: sectionData.sortOption)
        }
        
    }
    
//    @objc func updateGymNameNDate() {
//        let data = DataManager.shared.repository.rawVideoInformation[0]
//        DataManager.shared.updateDateAndGymData(videoInformation: data, gymVisitDate: Date(), gymName: "SOMEWHERE")
//    }
//
//    @objc func updateProbLevelNPF() {
//        let data = DataManager.shared.repository.rawVideoInformation[0]
//        DataManager.shared.updateLevelAndPF(videoInformation: data, problemLevel: 45, isSucceeded: true)
//    }
//
//    @objc func updateProbFeedback() {
//        let data = DataManager.shared.repository.rawVideoInformation[0]
//        DataManager.shared.updateFeedback(videoInformation: data, feedback: "BLABHAHAHAAAA")
//    }
    
    @objc func deleteSingleInfo() {
        let data = DataManager.shared.repository.rawVideoInformation[0]
        DataManager.shared.deleteData(videoInformation: data)
    }
    
    @objc func deleteAllInfo () {
        DataManager.shared.deleteAllData()
    }

    
    /*
     1. 업로드 시의 데이터를 DataManager의 Create 메소드를 통해 저장한다.
     VC 1. viewDidAppear에서 DataManager의 전체 RawData Sort 메소드를 호출한다.
     */
    func caseCREATE() {
        
    }
    
    /* 1. Home View Controller 측에서 Sorting 기준에 따라 달라진다.
     */
    func caseREAD() {
        
    }
    
    /*
     1. DataManager의 Update 메소드를 통해 저장한다.
     VC1. 현재 Cell의 1차원 배열에 대해 Sorting을 다시 한다.
     VC2. 갱신한다
     */
    func caseUPDATE() {
        let data = DataManager.shared.repository.rawVideoInformation.filter({$0.gymName == currentGymName})[0]
        DataManager.shared.updateDateAndGymData(videoInformation: data, gymVisitDate: Date(), gymName: "SOMEWHERE")
        
        DataManager.shared.printRawData(standard: sectionData.sortOption)
        
    }
    
    /*
     1. DataManager의 Delete 메소드를 통해 저장한다.
     VC1. 현재 Cell의 1차원 배열에 대해 Sorting을 다시 한다.
     VC2. 갱신한다
     */
    func caseDELETE() {
        let data = DataManager.shared.repository.rawVideoInformation.filter({$0.gymName == currentGymName})[0]
        DataManager.shared.deleteData(videoInformation: data)
    }
    
    func printData(info: VideoInformation, primarySortOption: SortOption) {
        
        if primarySortOption == .gymName {
            print("\(info.gymName) | \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.videoUrl) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        } else {
            print("| \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.gymName) | \(info.videoUrl) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        }
    }
}
