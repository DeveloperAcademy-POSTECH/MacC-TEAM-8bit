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
    
}
