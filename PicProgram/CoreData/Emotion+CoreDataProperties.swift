//
//  Emotion+CoreDataProperties.swift
//  
//
//  Created by sliencio on 2017/12/11.
//
//

import Foundation
import CoreData


extension Emotion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emotion> {
        return NSFetchRequest<Emotion>(entityName: "Emotion")
    }

    @NSManaged public var emotion_id: Int16
    @NSManaged public var emotion_name: String?
    @NSManaged public var pictures: NSSet?

}

// MARK: Generated accessors for pictures
extension Emotion {

    @objc(addPicturesObject:)
    @NSManaged public func addToPictures(_ value: Picture)

    @objc(removePicturesObject:)
    @NSManaged public func removeFromPictures(_ value: Picture)

    @objc(addPictures:)
    @NSManaged public func addToPictures(_ values: NSSet)

    @objc(removePictures:)
    @NSManaged public func removeFromPictures(_ values: NSSet)

}
