//
//  Picture+CoreDataProperties.swift
//  
//
//  Created by sliencio on 2018/1/24.
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
    @NSManaged public var size: String?
    @NSManaged public var time: String?
    @NSManaged public var title: String?
    @NSManaged public var save_time: Int64
    @NSManaged public var emotion: Emotion?
    @NSManaged public var historyPics: HistoryPic?
    @NSManaged public var paint: Paint?

}
