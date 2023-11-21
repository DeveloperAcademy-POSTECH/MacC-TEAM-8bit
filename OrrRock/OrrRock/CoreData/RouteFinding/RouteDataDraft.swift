//
//  RouteDataDraft.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/24.
//

import Foundation

final class RouteDataDraft {
    
    var routeDataManager: RouteDataManager!
    
    var route: RouteInformation?
    
    var routeInfoForUI: RouteInfo!
    
    // 새롭게 추가할 Page에 대한 배열
    var newPageInfo: [PageInfo] = []
    
//    var pages: [PageInformation] = []
    
    // imageLocalIdentififer는 '사진 앱'에서 새로운 데이터를 들고와 추가하는 작업을 하는 경우 필요
    init(manager: RouteDataManager, existingRouteFinding routeFinding: RouteInformation?, imageLocalIdentifier: String) {
        
        routeDataManager = manager
        
        // CASE: 새로운 루트 추가 OR 기존 루트 수정
        route = routeFinding
        guard let route = route
        else {
            let pageInfo = PageInfo(rowOrder: 0, points: [])
            routeInfoForUI = RouteInfo(imageLocalIdentifier: imageLocalIdentifier, dataWrittenDate: Date(), gymName: "", problemLevel: 0, isChallengeComplete: false, pages: [pageInfo])
            newPageInfo.append(pageInfo)
            return
        }
        
        routeInfoForUI = route.convertToRouteInfo()
    }
    
    func save() {
          
        var routeInfo: RouteInfo? = nil
        // MODE: ADD_데이터 추가
        if route == nil {
            routeDataManager.addRoute(routeInfo: routeInfoForUI)
            routeDataManager.saveData()
        } else { // MODE: EDIT_데이터 수정
            guard let routeInformation = route else { return }
            routeDataManager.deleteRouteData(routeInformation: routeInformation)
            routeDataManager.addRoute(routeInfo: routeInfoForUI)
            routeDataManager.saveData()
            routeInfo = routeInfoForUI
        }
    }
    
    // MARK: CREATE PAGE
    func addPageData(pageInfo: PageInfo) {
        routeInfoForUI.pages.append(pageInfo)
        newPageInfo.append(pageInfo)
    }
    
    // MARK: REMOVE PAGE
    func removePageData(at pageIndex: Int) {
        
        // UI DATA PART: UI를 구성하는 데이터에서 삭제
        let removePageInfoData = routeInfoForUI.pages[pageIndex]
        routeInfoForUI.pages.remove(at: pageIndex)
    }
    
    // MARK: CREATE POINT
    func addPointData(pageAt pageIndex: Int, addTargetPointInfo pointInfo: PointInfo) {

        // UI DATA PART: UI를 구성하는 데이터에 추가
        routeInfoForUI.pages[pageIndex].points.append(pointInfo)
        
        
        guard route == nil else { return }
        let index = newPageInfo.firstIndex(where: { $0.rowOrder == routeInfoForUI.pages[pageIndex].rowOrder })!
        
        // COREDATA PART - CASE.1: 페이지가 '추가될 데이터'에 존재하는 경우
        newPageInfo[index].points.append(pointInfo)
    }
    
    // MARK: DELETE POINT
    func removePointData(pageAt pageIndex: Int, pointIndexOf pointIndex: Int) {
        
        // UI DATA PART: UI를 구성하는 데이터에서 삭제
        routeInfoForUI.pages[pageIndex].points.remove(at: pointIndex)
    }
    
    // MARK: UPDATE POINT
    func updatePointData(pageAt pageIndex: Int, pointIndexOf pointIndex: Int, updateTargetPointInfo targetPointInfo: PointInfo) {
        
        let page = routeInfoForUI.pages[pageIndex]
        let existPoint: PointInfo = page.points[pointIndex]
        
        // UI DATA PART: UI를 구성하는 데이터에서 업데이트(수정)
        guard let routeInfoForUIIndex = routeInfoForUI.pages[pageIndex].points.firstIndex(of: existPoint) else { return }
        routeInfoForUI.pages[pageIndex].points[routeInfoForUIIndex] = targetPointInfo
    }

    // MARK: Update Gym Name in RouteFindingGymSaveViewController
    func updateGymName(gymName: String) {
        routeInfoForUI.gymName = gymName
    }
    // MARK: Update Problem Level in RouteFindingLevelSaveViewController
    func updateProblemLevel(problemLevel: Int) {
        routeInfoForUI.problemLevel = problemLevel
    }
}
