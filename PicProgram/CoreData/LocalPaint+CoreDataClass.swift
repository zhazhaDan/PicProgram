//
//  LocalPaint+CoreDataClass.swift
//  
//
//  Created by sliencio on 2017/12/10.
//
//

import Foundation
import CoreData


public class LocalPaint: NSManagedObject {
    @nonobjc public class func fetchAllLocalPaint() -> Array<LocalPaint>? {
        let fetchRequest: NSFetchRequest<LocalPaint> = LocalPaint.fetchRequest()
        do {
            let fetchedResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
               return results as! [LocalPaint]
            }
            
        } catch  {
            fatalError("获取失败")
        }
        return nil
    }
    var pictureModels : Array<PictureModel> {
        get{
            var array:Array<PictureModel> = Array()
            for pic in self.pics! {
                let model = PictureModel.init()
                model.picture_url = (pic as! Picture).picture_url!
                model.picture_id = Int((pic as! Picture).picture_id)
                if (pic as! Picture).detail_url != nil {
                    model.detail_url = (pic as! Picture).detail_url!
                }
                if (pic as! Picture).title != nil {
                    model.title = (pic as! Picture).title!
                }
                array.append(model)
            }
            return array
        }
    }
}
