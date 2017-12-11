//
//  LocalPaint+CoreDataProperties.swift
//  
//
//  Created by sliencio on 2017/12/11.
//
//

import Foundation
import CoreData


extension LocalPaint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalPaint> {
        return NSFetchRequest<LocalPaint>(entityName: "LocalPaint")
    }

    @NSManaged public var cover_url: String?
    @NSManaged public var id: Int64
    @NSManaged public var introduce: String?
    @NSManaged public var name: String?
    @NSManaged public var pics: NSSet?

}

// MARK: Generated accessors for pics
extension LocalPaint {

    @objc(addPicsObject:)
    @NSManaged public func addToPics(_ value: Picture)

    @objc(removePicsObject:)
    @NSManaged public func removeFromPics(_ value: Picture)

    @objc(addPics:)
    @NSManaged public func addToPics(_ values: NSSet)

    @objc(removePics:)
    @NSManaged public func removeFromPics(_ values: NSSet)

}
