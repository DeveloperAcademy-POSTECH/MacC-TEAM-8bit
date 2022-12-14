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
    
    func createRouteInformationData(routeInfo: RouteInfo) -> NSManagedObject {
        let routeInformation = NSEntityDescription.insertNewObject(forEntityName: "RouteInformation", into: context)
        
        routeInformation.setValue(UUID(), forKey: "id")
        routeInformation.setValue(routeInfo.imageLocalIdentifier, forKey: "imageLocalIdentifier")
        routeInformation.setValue(routeInfo.gymName, forKey: "gymName")
        routeInformation.setValue(routeInfo.dataWrittenDate, forKey: "dataWrittenDate")
        routeInformation.setValue(routeInfo.problemLevel, forKey: "problemLevel")
        routeInformation.setValue(routeInfo.isChallengeComplete, forKey: "isChallengeComplete")
        
        if routeInfo.pages.count != 0 {
            routeInfo.pages.forEach({ pageInfo in
                createPageInformation(pageInfo: pageInfo, routeInformation: routeInformation as! RouteInformation)
            })
        }
        return routeInformation
    }
    
    func updateRouteInformationDataWrittenDate(date: Date, routeInformation: RouteInformation) {
        guard let id = routeInformation.id else { return }
        let request = RouteInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let tempInfo = info.first {
                tempInfo.setValue(date, forKey: "dataWrittenDate")
            }
        } catch {
            print("CoreDataDAO UpateRoute Method \(error.localizedDescription)")
        }
    }
    
    func updateRouteInformationGymName(gymName: String, routeInformation: RouteInformation) {
        guard let id = routeInformation.id else { return }
        let request = RouteInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let tempInfo = info.first {
                tempInfo.setValue(gymName, forKey: "gymName")
            }
        } catch {
            print("CoreDataDAO UpateRoute Method \(error.localizedDescription)")
        }
    }
    
    func updateRouteInformationLevelAndStatus(status: Bool, problemLevel: Int, routeInformation: RouteInformation) {
        guard let id = routeInformation.id else { return }
        let request = RouteInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let tempInfo = info.first {
                tempInfo.setValue(status, forKey: "isChallengeComplete")
                tempInfo.setValue(problemLevel, forKey: "problemLevel")
            }
        } catch {
            print("CoreDataDAO UpateRoute Method \(error.localizedDescription)")
        }
    }
    
    func updateRouteInformationStatus(status: Bool, routeInformation: RouteInformation) {
        guard let id = routeInformation.id else { return }
        let request = RouteInformation.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let tempInfo = info.first {
                tempInfo.setValue(status, forKey: "isChallengeComplete")
            }
        } catch {
            print("CoreDataDAO UpateRoute Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    func createPageInformation(pageInfo: PageInfo, routeInformation: RouteInformation) {
        print("MAKE PAGE")
        let page = PageInformation(context: context)
        page.rowOrder = Int64(pageInfo.rowOrder)
        page.setValue(UUID(), forKey: "id")
        routeInformation.addToPages(page)
        
        createPointInformation(pointInfoList: pageInfo.points, pageInformation: page)
    }
    
    func createPointInformation(pointInfoList: [PointInfo], pageInformation: PageInformation) {
        for info in pointInfoList {
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
    
    func deletePageData(pageInformationList: [PageInformation], routeInformation: RouteInformation) {
        for page in pageInformationList {
            routeInformation.removeFromPages(page)
        }
        saveData()
    }
    
    func deletePointData(removePointList: [PageInformation : [PointInformation]]) {
        for (key, value) in removePointList {
            for point in value {
                key.removeFromPoints(point)
            }
        }
        saveData()
    }
    
    func deleteAllData() {
        let objects = readRouteFindingData()
        
        if objects.count > 0 {
            for object in objects {
                context.delete(object)
            }
            saveData()
        }
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("CoreDataManager SaveData Method \(error.localizedDescription)")
        }
    }

}
