//
//  Picture+CoreDataProperties.swift
//  
//
//  Created by 龚丹丹 on 2017/12/10.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var picture_id: Int64
    @NSManaged public var picture_url: String?
    @NSManaged public var paint: Paint?
    @NSManaged public var emotion: Emotion?

}
