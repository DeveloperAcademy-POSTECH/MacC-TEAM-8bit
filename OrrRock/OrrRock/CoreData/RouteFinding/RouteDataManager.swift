//
//  RouteDataManager.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import Foundation

final class RouteDataManager {
    
    private var coreDataDAO: RouteCoreDataDAO
    private var routeFindingList: [RouteInformation] = []
    
    init() {
        coreDataDAO = RouteCoreDataDAO()
        //MARK: RouteDataMainSampleDataGenerate
        // deleteAllData()
        // randomRouteGenerate(for: 10)
        // 추가된 코드
        
        updateRepository()

    }
    
    func updateRepository() {
        routeFindingList = coreDataDAO.readRouteFindingData()
    }
    
    func getRouteFindingList() -> [RouteInformation] {
        return routeFindingList
    }
    
    func getSpecificRouteFindingList(isChallengeComplete: Bool) -> [RouteInformation] {
        return routeFindingList.filter({ $0.isChallengeComplete == isChallengeComplete })
    }
    
    func addRoute(routeInfo: RouteInfo) {
        let routeFinding = coreDataDAO.createRouteInformationData(routeInfo: routeInfo) as! RouteInformation
        routeFindingList.append(routeFinding)
    }
    
    func updateRouteDataWrittenDate(to date: Date, of routeInformation: RouteInformation) {
        coreDataDAO.updateRouteInformationDataWrittenDate(date: date, routeInformation: routeInformation)
    }
    
    func updateRouteGymName(to gymName: String, of routeInformation: RouteInformation) {
        coreDataDAO.updateRouteInformationGymName(gymName: gymName, routeInformation: routeInformation)
    }
    
    func updateRouteLevelAndStatus(statusTo status: Bool, levelTo level: Int, of routeInformation: RouteInformation) {
        coreDataDAO.updateRouteInformationLevelAndStatus(status: status, problemLevel: level, routeInformation: routeInformation)
    }
    
    func updateRouteStatus(to status: Bool, of routeInformation: RouteInformation) {
        coreDataDAO.updateRouteInformationStatus(status: status, routeInformation: routeInformation)
    }
    
    func addPageData(pageInfoList: [PageInfo], routeInformation: RouteInformation) {
        for info in pageInfoList {
            coreDataDAO.createPageInformation(pageInfo: info, routeInformation: routeInformation)
        }
    }
    
    func addPointData(pointInfoList: [PageInformation : [PointInfo]]) {
        for (key, value) in pointInfoList {
            coreDataDAO.createPointInformation(pointInfoList: value, pageInformation: key)
        }
    }
    
    func updatePointData(pointInfoList: [PageInformation : [(PointInformation, PointInfo)]]) {
        for (key, value) in pointInfoList {
            for pointData in value {
                coreDataDAO.updatePointData(pageInformation: key, targetPoint: pointData.0, data: pointData.1)
            }
        }
        coreDataDAO.saveData()
    }
    
    func deleteRouteData(routeInformation: RouteInformation) {
        coreDataDAO.deleteRouteFindingData(routeFinding: routeInformation)
        guard let index = routeFindingList.firstIndex(of: routeInformation) else { return }
        routeFindingList.remove(at: index)
        saveData()
    }
    
    func deletePageData(pageInformationList: [PageInformation], routeFinding: RouteInformation) {
        coreDataDAO.deletePageData(pageInformationList: pageInformationList, routeInformation: routeFinding)
    }
    
    func deletePointData(removePointList: [PageInformation : [PointInformation]]) {
        coreDataDAO.deletePointData(removePointList: removePointList)
    }
    
    func saveData() {
        coreDataDAO.saveData()
    }
    
    func deleteAllData() {
        coreDataDAO.deleteAllData()
    }
    
    //MARK: RouteDataMainSampleDataGenerate
    func randomRouteGenerate(for num: Int) {
        
        let randomGymNameList: [String] = ["클라이밍 Alpha", "Beta 클라이밍", "C 클라임", "Grand Climb"]
        let randomBool: [Bool] = [true, false]
        
        for _ in 0..<num {
            let randomDate = Date.randomBetween(start: Date(timeIntervalSince1970: 30000), end: Date(timeIntervalSince1970: 300000000))
            let randomGymName = randomGymNameList[Int.random(in: 0..<randomGymNameList.count)]
            let randomProblemLevel = Int.random(in: 0...9)
            let randomBool = randomBool[Int.random(in: 0...1)]
            let pageGenerateNum = Int.random(in: 1..<5)
            let pageInfoList: [PageInfo] = randomPageListGenerate(for: pageGenerateNum)
            let routeInfo = RouteInfo(imageLocalIdentifier: "", dataWrittenDate: randomDate, gymName: randomGymName, problemLevel: randomProblemLevel, isChallengeComplete: randomBool, pages: pageInfoList)
            
            coreDataDAO.createRouteInformationData(routeInfo: routeInfo)
        }
        saveData()
    }
    
    //MARK: RouteDataMainSampleDataGenerate
    func randomPageListGenerate(for num: Int) -> [PageInfo] {
        var pageList: [PageInfo] = []
        for i in 0..<num {
            pageList.append(PageInfo(rowOrder: i, points: []))
        }
        return pageList
    }
}
