//
//  Picture+CoreDataProperties.swift
//  
//
//  Created by sliencio on 2017/12/11.
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
    @NSManaged public var detail_url: String?
    @NSManaged public var title: String?
    @NSManaged public var emotion: Emotion?
    @NSManaged public var historyPics: HistoryPic?
    @NSManaged public var paint: Paint?
    @NSManaged public var localPaint: LocalPaint?

}
