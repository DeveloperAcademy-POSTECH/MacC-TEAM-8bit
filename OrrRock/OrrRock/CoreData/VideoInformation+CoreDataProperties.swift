//
//  VideoInformation+CoreDataProperties.swift
//  OrrRock
//
//  Created by 8Bit on 2022/10/25.
//
//

import Foundation
import CoreData


extension VideoInformation {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoInformation> {
        return NSFetchRequest<VideoInformation>(entityName: "VideoInformation")
    }
    
    @NSManaged public var feedback: String?
    @NSManaged public var gymName: String
    @NSManaged public var gymVisitDate: Date
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isSucceeded: Bool
    @NSManaged public var problemLevel: Int16
    @NSManaged public var videoLocalIdentifier: String?
    
}

extension VideoInformation : Identifiable {
    
}
