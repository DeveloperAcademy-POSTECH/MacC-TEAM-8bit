//
//  RouteCoreDataDAO.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import UIKit
import CoreData

class RouteCoreDataDAO {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    init() {}
    
    // R 구조체를 매개변수로 받아 RouteFinding NSManagedObject에 추가
    func createRouteInformationData(routeInfo: RouteInfo) -> NSManagedObject {
        let routeInformation = NSEntityDescription.insertNewObject(forEntityName: "RouteInformation", into: context)
        
        routeInformation.setValue(UUID(), forKey: "id")
        routeInformation.setValue(routeInfo.gymName, forKey: "gymName")
        routeInformation.setValue(routeInfo.dataWrittenDate, forKey: "dataWrittenDate")
        routeInformation.setValue(routeInfo.problemLevel, forKey: "problemLevel")
        routeInformation.setValue(routeInfo.isChallengeComplete, forKey: "isChallengeComplete")
        
        if routeInfo.pages.count == 0 {
            print("THERE's NO PAGE...")
        } else {
            routeInfo.pages.forEach({ pageInfo in
                createPageData(pageInfo: pageInfo, routeFinding: routeInformation as! RouteInformation)
            })
        }
        return routeInformation
    }
    
    func updateRoute(routeInfo: RouteInfo, route: RouteInformation) {
        guard let id = route.id else { return }
        let request = RouteInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let tempInfo = info.first {
                tempInfo.setValue(routeInfo.dataWrittenDate, forKey: "dataWrittenDate")
                tempInfo.setValue(routeInfo.gymName, forKey: "gymName")
                tempInfo.setValue(routeInfo.isChallengeComplete, forKey: "isChallengeComplete")
                tempInfo.setValue(routeInfo.problemLevel, forKey: "problemLevel")
            }
        } catch {
            print("CoreDataDAO UpateRoute Method \(error.localizedDescription)")
        }
    }
    
    func createPageData(pageInfo: PageInfo, routeFinding: RouteInformation) {
        let page = PageInformation(context: context)
        page.rowOrder = Int64(pageInfo.rowOrder)
        page.setValue(UUID(), forKey: "id")
        routeFinding.addToPages(page)
        
        guard let points = pageInfo.points else { return }
        createPointData(pointInformation: points, pageInformation: page)
    }
    
    func createPointData(pointInformation: [PointInfo], pageInformation: PageInformation) {
        for info in pointInformation {
            let bodyPoint = PointInformation(context: context)
            bodyPoint.id = UUID()
            bodyPoint.footOrHand = (info.footOrHand.rawValue)
            bodyPoint.isForce = info.isForce
            bodyPoint.xCoordinate = info.position.x
            bodyPoint.yCoordinate = info.position.y
            bodyPoint.forceDirection = Int16(info.forceDirection.rawValue)
            
            pageInformation.addToPoints(bodyPoint)
        }
    }
    
    // Core Data의 읽어 RouteFinding 클래스를 반환합니다.
    func readRouteFindingData() -> [RouteInformation] {
        let request = RouteInformation.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dataWrittenDate", ascending: false)]
        var information: [RouteInformation] = []
        do {
            information = try context.fetch(request)
            
        } catch {
            print("CoreDataManager ReadData Method \(error.localizedDescription)")
        }
        
        return information
    }
    
    func updatePointData(pageInformation: PageInformation, targetPoint: PointInformation, data: PointInfo) {
        guard let id = targetPoint.id else { return }
        let request = PointInformation.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@",  id as CVarArg)
        do {
            let info = try context.fetch(request)
                if let tempInfo = info.first {
                    tempInfo.xCoordinate = data.position.x
                    tempInfo.yCoordinate = data.position.y
                    tempInfo.forceDirection = Int16(data.forceDirection.rawValue)
                    tempInfo.setValue(data.isForce, forKey: "isForce")
                    tempInfo.setValue(data.footOrHand.rawValue, forKey: "footOrHand")
                    print(tempInfo)
                }
        } catch {
            print("CoreDataDAO UpdatePointData Method \(error.localizedDescription)")
        }
    }

    func deleteRouteFindingData(routeFinding: RouteInformation) {
        
        guard let id = routeFinding.id else { return }
        let request = RouteInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let tempInfo = info.first {
                context.delete(tempInfo)
            }
        } catch {
            print("CoreDataManager DeleteData Method \(error.localizedDescription)")
        }
    }
    
}
