//
//  RouteInformation+CoreDataProperties.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//
//

import Foundation
import CoreData


extension RouteInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteInformation> {
        return NSFetchRequest<RouteInformation>(entityName: "RouteInformation")
    }

    @NSManaged public var dataWrittenDate: Date
    @NSManaged public var gymName: String
    @NSManaged public var id: UUID?
    @NSManaged public var isChallengeComplete: Bool
    @NSManaged public var problemLevel: Int16
    @NSManaged public var imageLocalIdentifier: String
    @NSManaged public var pages: NSSet?

}

// MARK: Generated accessors for pages
extension RouteInformation {

    @objc(addPagesObject:)
    @NSManaged public func addToPages(_ value: PageInformation)

    @objc(removePagesObject:)
    @NSManaged public func removeFromPages(_ value: PageInformation)

    @objc(addPages:)
    @NSManaged public func addToPages(_ values: NSSet)

    @objc(removePages:)
    @NSManaged public func removeFromPages(_ values: NSSet)

}

extension RouteInformation : Identifiable {

}
