//
//  Picture+CoreDataClass.swift
//  
//
//  Created by 龚丹丹 on 2017/12/10.
//
//

import Foundation
import CoreData


public class Picture: NSManagedObject {
    //NSPredicate
    @nonobjc public class func fetchPicture(forPicId id : Int64) -> Picture? {
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        let predicate = NSPredicate.init(format: "picture_id==\(id)", argumentArray: nil)
        fetchRequest.predicate = predicate
        do {
            let fetchedResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                if results.count > 0 {
                    return results.first as? Picture
                }
            }
            
        } catch  {
            fatalError("获取失败")
        }
        return nil

    }
}
