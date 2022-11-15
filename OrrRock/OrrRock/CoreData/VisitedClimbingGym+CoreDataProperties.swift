//
//  VisitedClimbingGym+CoreDataProperties.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/15.
//


import Foundation
import CoreData


extension VisitedClimbingGym {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitedClimbingGym> {
        return NSFetchRequest<VisitedClimbingGym>(entityName: "VisitedClimbingGym")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var createdDate: Date
    
}

extension VisitedClimbingGym : Identifiable {
    
}
