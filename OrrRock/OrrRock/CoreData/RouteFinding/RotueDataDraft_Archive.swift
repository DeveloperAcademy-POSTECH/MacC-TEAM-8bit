//
//  RotueDataDraft_Archive.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/30.
//

import Foundation

final class RouteDataDraft_Archive {
    
    var routeDataManager: RouteDataManager!
    
    // isModalType == false && 기존에 존재하는 데이터를 들고올 때
    var route: RouteInformation?
    
    // isModalType == true && 새롭게 데이터를 추가하는 경우
    var routeInfoForUI: RouteInfo!
    
    // 새롭게 추가할 Page에 대한 배열
    var newPageInfo: [PageInfo] = []
    
    // 새롭게 추가할 Point에 대한 배열
    var newPointInfo: [PageInformation : [PointInfo]] = [:]
    
    // 기존에 존재하는 Page의 Point 데이터 중 삭제할 Point에 대한 배열
    var updatePointInfo: [PageInformation : [(PointInformation, PointInfo)]] = [:]
    
    // 기존에 존재하는 데이터 중 삭제할 Page에 대한 배열
    var removePageList: [PageInformation] = []
    
    // 기존에 존재하는 데이터 중 삭제할 BodyPoint에 대한 배열
    var removePointList: [PageInformation : [PointInformation]] = [:]
    
    var pages: [PageInformation] = []
    
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
        print(routeInfoForUI.pages.count)
        let array = Array(route.pages as! Set<PageInformation>)
        pages = array.sorted(by: {$0.rowOrder > $1.rowOrder})
    }
    
    func save() {
          
        // MODE: ADD_데이터 추가
        if route == nil {
            routeDataManager.addRoute(routeInfo: routeInfoForUI)
        } else { // MODE: EDIT_데이터 수정
            guard let routeInformation = route else { return }
            routeDataManager.deleteRouteData(routeInformation: routeInformation)
            routeDataManager.addRoute(routeInfo: routeInfoForUI)
//            if let route = route {
//
//                // CREATE & UPDATE
//                // 기존 데이터에 새로운 페이지(+ 하위의 새로운 포인트) 추가
//                routeDataManager.addPageData(pageInfoList: newPageInfo, routeInformation: route)
//                // 기존 데이터, 기존 페이지에 새로운 포인트 추가
//                routeDataManager.addPointData(pointInfoList: newPointInfo)
//
//                // DELETE
//                // 기존 데이터의 페이지 제거
//                routeDataManager.deletePageData(pageInformationList: removePageList, routeFinding: route)
//                //  기존 데이터, 기존 페이지에 존재하는 포인트 제거
//                routeDataManager.deletePointData(removePointList: removePointList)
//
//                // UPDATE
//                // 기존 데이터, 기존 페이지에 존재하는 포인트 수정
//                if updatePointInfo.isEmpty == false {
//                    routeDataManager.updatePointData(pointInfoList: updatePointInfo)
//                }
//            }
        }
        
        routeDataManager.saveData()
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
        
//        // COREDATA PART - CASE.1: 페이지가 '추가될 데이터'에 존재하는 경우
//        let pageIndex = newPageInfo.firstIndex(where: { $0.rowOrder == removePageInfoData.rowOrder})!
//        newPageInfo.remove(at: pageIndex)
////        let indices = newPageInfo.filter({ $0.rowOrder == removePageInfoData.rowOrder}).indices
////        if indices.count > 0 {
////            newPageInfo.remove(at: indices[0])
////        }
//
//        // COREDATA PART - CASE.2: 페이지가 '기존의 데이터'에 존재하는 경우
//        if route != nil && pages.count > pageIndex {
//            let removePageData = pages[pageIndex]
//            removePageList.append(removePageData)
//        }
    }
    
    // MARK: CREATE POINT
    func addPointData(pageAt pageIndex: Int, addTargetPointInfo pointInfo: PointInfo) {

        // UI DATA PART: UI를 구성하는 데이터에 추가
        routeInfoForUI.pages[pageIndex].points.append(pointInfo)
        
        
        guard route == nil else { return }
        let index = newPageInfo.firstIndex(where: { $0.rowOrder == routeInfoForUI.pages[pageIndex].rowOrder })!
        
        // COREDATA PART - CASE.1: 페이지가 '추가될 데이터'에 존재하는 경우
        newPageInfo[index].points.append(pointInfo)
        
//        else { // COREDATA PART - CASE.2: 페이지가 '기존의 데이터'에 존재하는 경우
//            if newPointInfo[pages[pageIndex]] == nil {
//                newPointInfo[pages[pageIndex]] = []
//            }
//            newPointInfo[pages[pageIndex]]?.append(pointInfo)
//        }
    }
    
    // MARK: DELETE POINT
    func removePointData(pageAt pageIndex: Int, pointIndexOf pointIndex: Int) {
        
        // UI DATA PART: UI를 구성하는 데이터에서 삭제
        routeInfoForUI.pages[pageIndex].points.remove(at: pointIndex)
        
        // COREDATA PART - CASE.1: 포인트에 대한 페이지가 '기존에 데이터'로 존재하는 경우
        if pages.count > pageIndex {
            let points = Array(pages[pageIndex].points as! Set<PointInformation>)
            if points.count > pointIndex {
                let removePointData = points[pointIndex]
                if removePointList[pages[pageIndex]] == nil {
                    removePointList[pages[pageIndex]] = []
                }
                removePointList[pages[pageIndex]]?.append(removePointData)
            }
            
        // COREDATA PART - CASE.2: 포인트에 대한 페이지가 '추가될 데이터'로 존재하는 경우
        } else {
            guard route == nil else { return }
//            let indices = newPageInfo.filter({ $0.rowOrder == routeInfoForUI.pages[pageIndex].rowOrder}).indices
//            if indices.count > 0 {
//                newPageInfo[indices[0]].points.remove(at: pointIndex)
//            }
            let pageIndex = newPageInfo.firstIndex(where: { $0.rowOrder == routeInfoForUI.pages[pageIndex].rowOrder})!
            newPageInfo[pageIndex].points.remove(at: pointIndex)
        }
    }
    
    // MARK: UPDATE POINT
    func updatePointData(pageAt pageIndex: Int, pointIndexOf pointIndex: Int, updateTargetPointInfo targetPointInfo: PointInfo) {
        
        let page = routeInfoForUI.pages[pageIndex]
//        guard let points = page.points else { return }
        let existPoint: PointInfo = page.points[pointIndex]
        
        // UI DATA PART: UI를 구성하는 데이터에서 업데이트(수정)
        guard let routeInfoForUIIndex = routeInfoForUI.pages[pageIndex].points.firstIndex(of: existPoint) else { return }
        routeInfoForUI.pages[pageIndex].points[routeInfoForUIIndex] = targetPointInfo
        
        // COREDATA PART - CASE.1: 기존에 존재하는 페이지인 경우
        if pages.filter({$0.rowOrder == page.rowOrder}).count > 0 {

            let points = Array(pages[pageIndex].points as! Set<PointInformation>)
//            let point = points.filter({ CGPoint(x: $0.xCoordinate, y: $0.yCoordinate) == existPoint.position })
            let point = points.filter({ $0.id == existPoint.id })
            print(point)
            if point.count > 0 {
                print("기존 포인트")
                // COREDATA PART - CASE.1a:  기존에 존재하는 페이지에 존재하는 기존 포인트인 경우
                if updatePointInfo[pages[pageIndex]] == nil {
                    updatePointInfo[pages[pageIndex]] = []
                }
                
                print(updatePointInfo)
                
                updatePointInfo[pages[pageIndex]]?.append((point[0], targetPointInfo))
            } else {
                print("기존 페이지 새 포인트")
                // COREDATA PART - CASE.1b:  기존에 존재하는 페이지에 존재하는 새로운 포인트인 경우
//                guard let indices = newPointInfo[pages[pageIndex]]?.filter({$0 == existPoint}).indices else { return }
//                newPointInfo[pages[pageIndex]]?[indices[0]] = targetPointInfo
                let existPointIndex = newPointInfo[pages[pageIndex]]?.firstIndex(where: {$0 == existPoint})!
                newPointInfo[pages[pageIndex]]?[existPointIndex!] = targetPointInfo
            }
        } else {
            // COREDATA PART - CASE.2: 새롭게 추가되는 페이지인 경우
            let index = newPageInfo.firstIndex(where: { $0.rowOrder == page.rowOrder })!
            
            guard let pointIndex = newPageInfo[index].points.firstIndex(where: { $0 == existPoint }) else { return }
                newPageInfo[index].points[pointIndex] = targetPointInfo
            }
        }
    }
//
//    // MARK: Update Gym Name in RouteFindingGymSaveViewController
//    func updateGymName(gymName: String) {
//        routeInfoForUI.gymName = gymName
//    }
//    // MARK: Update Problem Level in RouteFindingLevelSaveViewController
//    func updateProblemLevel(problemLevel: Int) {
//        routeInfoForUI.problemLevel = problemLevel
//    }
//}
