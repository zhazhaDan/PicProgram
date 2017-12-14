//
//  Paint+CoreDataProperties.swift
//  
//
//  Created by sliencio on 2017/12/13.
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
    @NSManaged public var title_detail_url: String?
    @NSManaged public var title_url: String?
    @NSManaged public var flag: Int16
    @NSManaged public var paint_detail: String?
    @NSManaged public var read_num: Int64
    @NSManaged public var love_num: Int64
    @NSManaged public var collect_num: Int64
    @NSManaged public var paint_type: Int16 // 画单类型 1 我的画单 2是普通画单 3最近浏览
    @NSManaged public var pics: NSSet?

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
