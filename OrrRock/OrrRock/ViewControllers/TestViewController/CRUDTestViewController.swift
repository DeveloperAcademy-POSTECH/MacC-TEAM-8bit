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
        DataManager.shared.deleteAllData()
        let generator = RandomDataGenerator()
        generator.coreDataRandomvideoInformationGenerate(howMany: 30)
        
        // 기존 데이터로 테스트 시 주석 제거
//        DataManager.shared.updateRepository()
        
        DataManager.shared.printRawData(standard: .gymName)
        
        currentVideoInformation = DataManager.shared.repository.finalSortVideoInformation(filterOption: sectionData.filterOption, sortOption: sectionData.sortOption, orderOption: sectionData.orderOption)[0]
        
        currentGymName = sectionData.gymName
        print("CURRENT ", currentGymName)
        
        print("-> BEFORE: CURRENT DATA COUNT ", currentVideoInformation.count)
        
        for information in currentVideoInformation {
            printData(info: information, primarySortOption: sectionData.sortOption)
        }
        
        caseUPDATE_NameNDate()
        print("NAME N DATE")
        updateNPrint()
        
        caseUPDATE_PROB()
        print("PROB")
        updateNPrint()
        
        caseUPDATE_FEED()
        print("FEED")
        updateNPrint()
        
        caseUPDATE_FAV()
        print("FAV")
        updateNPrint()
        
//        caseDELETE()
//        caseDELETEAll()
        
    }
    
    func updateNPrint() {
        currentVideoInformation = sortVideoInformation(videoInformation: currentVideoInformation, sectionData: sectionData)
        
        print("-> AFTER: CURRENT DATA COUNT ", currentVideoInformation.count)
        
        for information in currentVideoInformation {
            printData(info: information, primarySortOption: sectionData.sortOption)
        }
    }
    
    /*
     1. 업로드 시의 데이터를 DataManager의 Create 메소드를 통해 저장한다.
     VC 1. viewDidAppear에서 DataManager의 전체 RawData Sort 메소드를 호출한다.
     */
    func caseCREATE() {
        let videoInfo = VideoInfo(gymName: "3암장", gymVisitDate: Date(), videoLocalIdentifier: "URL", problemLevel: 5, isSucceeded: false)
        DataManager.shared.createData(info: videoInfo)
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
    func caseUPDATE_NameNDate() {
        let data = DataManager.shared.repository.rawVideoInformation.filter({$0.gymName == currentGymName})[0]
        DataManager.shared.updateDateAndGymData(videoInformation: data, gymVisitDate: Date(), gymName: "SOMEWHERE")
    }
    
    func caseUPDATE_PROB() {
        let data = DataManager.shared.repository.rawVideoInformation.filter({$0.gymName == currentGymName})[0]
        DataManager.shared.updateLevelAndPF(videoInformation: data, problemLevel: 45, isSucceeded: true)
    }
    
    func caseUPDATE_FAV() {
        let data = DataManager.shared.repository.rawVideoInformation.filter({$0.gymName == currentGymName})[0]
        DataManager.shared.updateFavorite(videoInformation: data, isFavorite: true)
    }
    
    func caseUPDATE_FEED() {
        let data = DataManager.shared.repository.rawVideoInformation.filter({$0.gymName == currentGymName})[0]
        DataManager.shared.updateFeedback(videoInformation: data, feedback: "HI...")
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
    
    func caseDELETEAll() {
        DataManager.shared.deleteAllData()
    }
    
    func printData(info: VideoInformation, primarySortOption: SortOption) {
        
        if primarySortOption == .gymName {
            print("\(info.gymName) | \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.videoLocalIdentifier) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        } else {
            print("| \(info.gymVisitDate.formatted(date: .numeric, time: .omitted)) | \(info.gymName) | \(info.videoLocalIdentifier) | \(info.problemLevel) | 즐겨찾기 \(info.isFavorite) | 성공 \(info.isSucceeded)")
        }
    }
}
