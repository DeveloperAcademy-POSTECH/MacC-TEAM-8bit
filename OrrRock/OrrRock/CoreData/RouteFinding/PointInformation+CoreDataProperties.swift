//
//  PointInformation+CoreDataProperties.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//
//

import Foundation
import CoreData


extension PointInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointInformation> {
        return NSFetchRequest<PointInformation>(entityName: "PointInformation")
    }

    @NSManaged public var footOrHand: String?
    @NSManaged public var forceDirection: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var isForce: Bool
    @NSManaged public var xCoordinate: Double
    @NSManaged public var yCoordinate: Double
    @NSManaged public var page: PageInformation?

}

extension PointInformation : Identifiable {

}
