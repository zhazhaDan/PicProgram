//
//  HistoryPic+CoreDataProperties.swift
//  
//
//  Created by sliencio on 2017/12/10.
//
//

import Foundation
import CoreData


extension HistoryPic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryPic> {
        return NSFetchRequest<HistoryPic>(entityName: "HistoryPic")
    }

    @NSManaged public var pics: NSSet?

}

// MARK: Generated accessors for pics
extension HistoryPic {

    @objc(addPicsObject:)
    @NSManaged public func addToPics(_ value: Picture)

    @objc(removePicsObject:)
    @NSManaged public func removeFromPics(_ value: Picture)

    @objc(addPics:)
    @NSManaged public func addToPics(_ values: NSSet)

    @objc(removePics:)
    @NSManaged public func removeFromPics(_ values: NSSet)

}
