//
//  Paint+CoreDataProperties.swift
//  
//
//  Created by sliencio on 2017/12/11.
//
//

import Foundation
import CoreData


extension Paint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paint> {
        return NSFetchRequest<Paint>(entityName: "Paint")
    }

    @NSManaged public var paint_id: Int64
    @NSManaged public var paint_title: String?
    @NSManaged public var title_url: String?
    @NSManaged public var title_detail_url: String?
    @NSManaged public var pics: NSSet?
    @NSManaged public var localPaint: LocalPaint?

}

// MARK: Generated accessors for pics
extension Paint {

    @objc(addPicsObject:)
    @NSManaged public func addToPics(_ value: Picture)

    @objc(removePicsObject:)
    @NSManaged public func removeFromPics(_ value: Picture)

    @objc(addPics:)
    @NSManaged public func addToPics(_ values: NSSet)

    @objc(removePics:)
    @NSManaged public func removeFromPics(_ values: NSSet)

}
