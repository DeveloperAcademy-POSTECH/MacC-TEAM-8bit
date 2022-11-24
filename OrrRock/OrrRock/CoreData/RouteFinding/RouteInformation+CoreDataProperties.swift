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
    func routeInformationDraft() -> RouteInfo {
        let pageArray = Array(self.pages as! Set<PageInformation>)
        var pageInfo: [PageInfo] = []
        var points2dimensionArray: [[PointInfo]] = []
        for i in 0..<pageArray.count {
            let pointsArray = Array(pageArray[i].points as! Set<PointInformation>)
            var pointInfo: [PointInfo] = []
            for j in 0..<pointsArray.count {
                let temp = PointInfo(footOrHand: FootOrHand(rawValue: pointsArray[j].footOrHand) ?? FootOrHand.hand, isForce: pointsArray[j].isForce, primaryPosition: CGPoint(x: pointsArray[j].xCoordinate, y: pointsArray[j].yCoordinate), forceDirection: ForceDirection(rawValue: Int(pointsArray[j].forceDirection)) ?? ForceDirection.pi0)
                pointInfo.append(temp)
            }
            points2dimensionArray.append(pointInfo)
            pageInfo.append(PageInfo(rowOrder: Int(pageArray[i].rowOrder), points: points2dimensionArray[i]))
        }
        
        return RouteInfo(imageLocalIdentifier: self.imageLocalIdentifier, dataWrittenDate: self.dataWrittenDate, gymName: self.gymName, problemLevel: Int(self.problemLevel), isChallengeComplete: self.isChallengeComplete, pages: pageInfo)
    }

}
