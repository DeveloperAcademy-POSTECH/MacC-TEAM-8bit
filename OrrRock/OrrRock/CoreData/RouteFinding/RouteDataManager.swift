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
    
}
