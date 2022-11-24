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
