//
//  Picture+CoreDataProperties.swift
//  
//
//  Created by 龚丹丹 on 2018/1/26.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var detail: String?
    @NSManaged public var detail_url: String?
    @NSManaged public var picture_content: String?
    @NSManaged public var picture_id: Int64
    @NSManaged public var picture_type: Int16
    @NSManaged public var picture_url: String?
    @NSManaged public var save_time: Int64
    @NSManaged public var size: String?
    @NSManaged public var time: String?
    @NSManaged public var title: String?
    @NSManaged public var emotions: NSSet?
    @NSManaged public var historyPics: HistoryPic?
    @NSManaged public var paints: NSSet?

}

// MARK: Generated accessors for emotions
extension Picture {

    @objc(addEmotionsObject:)
    @NSManaged public func addToEmotions(_ value: Emotion)

    @objc(removeEmotionsObject:)
    @NSManaged public func removeFromEmotions(_ value: Emotion)

    @objc(addEmotions:)
    @NSManaged public func addToEmotions(_ values: NSSet)

    @objc(removeEmotions:)
    @NSManaged public func removeFromEmotions(_ values: NSSet)

}

// MARK: Generated accessors for paints
extension Picture {

    @objc(addPaintsObject:)
    @NSManaged public func addToPaints(_ value: Paint)

    @objc(removePaintsObject:)
    @NSManaged public func removeFromPaints(_ value: Paint)

    @objc(addPaints:)
    @NSManaged public func addToPaints(_ values: NSSet)

    @objc(removePaints:)
    @NSManaged public func removeFromPaints(_ values: NSSet)

}
