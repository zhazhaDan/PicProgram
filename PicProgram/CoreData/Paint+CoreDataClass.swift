//
//  Paint+CoreDataClass.swift
//  
//
//  Created by 龚丹丹 on 2017/12/10.
//
//

import Foundation
import CoreData


public class Paint: NSManagedObject {
    //NSPredicate
    @nonobjc public class func fetchPicture(forPaintId id : Int64) -> Paint? {
        let fetchRequest: NSFetchRequest<Paint> = Paint.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        let predicate = NSPredicate.init(format: "paint_id==\(id)", argumentArray: nil)
        fetchRequest.predicate = predicate
        do {
            let fetchedResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                if results.count > 0 {
                    return results.first as? Paint
                }
            }
            
        } catch  {
            fatalError("获取失败")
        }
        let entity = NSEntityDescription.entity(forEntityName: "Paint", in: appDelegate.managedObjectContext) as! NSEntityDescription
        let paint = NSManagedObject.init(entity: entity, insertInto: appDelegate.managedObjectContext) as! Paint
        paint.paint_id = id
        return paint
        
    }
}
