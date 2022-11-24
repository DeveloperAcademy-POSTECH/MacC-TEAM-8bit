//
//  RouteDataManager.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import Foundation

final class RouteDataManager {
    
    static var shared = RouteDataManager()
    
    private var coreDataDAO: RouteCoreDataDAO
    private var routeFindingList: [RouteInformation] = []
    
    init() {
        coreDataDAO = RouteCoreDataDAO()
        updateRepository()
    }
    
    // CoreData 정보를 DataRepository의 routeFindingList에 할당
    func updateRepository() {
        routeFindingList = coreDataDAO.readRouteFindingData()
    }
    
    func getRouteFindingList() -> [RouteInformation] {
        return routeFindingList
    }
    
    // MARK: CREATE ROUTE
    func addRoute(routeInfo: RouteInfo) {
        let routeFinding = coreDataDAO.createRouteInformationData(routeInfo: routeInfo) as! RouteInformation
        routeFindingList.append(routeFinding)
    }

    // MARK: UPDATE ROUTE
    func updateRoute(routeInfo: RouteInfo, route: RouteInformation) {
        coreDataDAO.updateRoute(routeInfo: routeInfo, route: route)
    }
    
    // MARK: CREATE PAGE
    func addPageData(pageInfo: [PageInfo], routeFinding: RouteInformation) {
        for info in pageInfo {
            coreDataDAO.createPageData(pageInfo: info, routeFinding: routeFinding)
        }
    }
    
    // MARK: CREATE POINT 포인트 추가
    func addPointData(pointInfo: [PageInformation : [PointInfo]]) {
        for (key, value) in pointInfo {
            coreDataDAO.createPointData(pointInformation: value, pageInformation: key)
        }
    }
    
    // MARK: UPDATE POINT 기존에 존재하는 포인트를 수정
    func updatePointData(pointInfo: [PageInformation : [(PointInformation, PointInfo)]]) {
        for (key, value) in pointInfo {
            for pointData in value {
                coreDataDAO.updatePointData(pageInformation: key, targetPoint: pointData.0, data: pointData.1)
            }
        }
        coreDataDAO.saveData()
    }
    
    // MARK: DELETE ROUTE
    func deleteRouteData(route: RouteInformation) {
        coreDataDAO.deleteRouteFindingData(routeFinding: route)
        guard let index = routeFindingList.firstIndex(of: route) else { return }
        routeFindingList.remove(at: index)
    }
    
    // MARK: DELETE PAGE
    func deletePagesData(pages: [PageInformation], routeFinding: RouteInformation) {
        coreDataDAO.deletePageData(pages: pages, routeFinding: routeFinding)
    }
    
    // MARK: DELETE POINT
    func deletePointsData(removePointList: [PageInformation : [PointInformation]]) {
        coreDataDAO.deletePointData(removePointList: removePointList)
    }
    
    func saveData() {
        coreDataDAO.saveData()
    }
    
    func deleteAllData() {
        coreDataDAO.deleteAllData()
    }
}
