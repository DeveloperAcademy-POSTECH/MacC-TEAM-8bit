//
//  PageInformation+CoreDataProperties.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//
//

import Foundation
import CoreData


extension PageInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PageInformation> {
        return NSFetchRequest<PageInformation>(entityName: "PageInformation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var rowOrder: Int64
    @NSManaged public var points: NSSet?
    @NSManaged public var routeFinding: RouteInformation?

}

// MARK: Generated accessors for points
extension PageInformation {

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: PointInformation)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: PointInformation)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSSet)

}

extension PageInformation : Identifiable {

}
