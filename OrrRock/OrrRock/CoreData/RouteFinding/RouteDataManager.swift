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
}
