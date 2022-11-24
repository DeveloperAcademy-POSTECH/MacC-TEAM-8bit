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
    
}
