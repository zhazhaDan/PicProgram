//
//  Emotion+CoreDataClass.swift
//  
//
//  Created by 龚丹丹 on 2017/12/10.
//
//

import Foundation
import CoreData


public class Emotion: NSManagedObject {
    //NSPredicate
    @nonobjc public class func fetchEmotionPaint(forEmotionName name : String) -> Emotion? {
        let fetchRequest: NSFetchRequest<Emotion> = Emotion.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        let predicate = NSPredicate.init(format: "emotion_name = \"\(name.utf8)\"", argumentArray: nil)
        fetchRequest.predicate = predicate
        do {
            let fetchedResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                if results.count > 0 {
                    return results.first as? Emotion
                }
            }
            
        } catch  {
            fatalError("获取失败")
        }
        let entity = NSEntityDescription.entity(forEntityName: "Emotion", in: appDelegate.managedObjectContext) as! NSEntityDescription
        let paint = NSManagedObject.init(entity: entity, insertInto: appDelegate.managedObjectContext) as! Emotion
        paint.emotion_name = name
        return paint
    }
    var pictureModels : Array<PictureModel> {
        get{
            var array:Array<PictureModel> = Array()
            for pic in self.pictures! {
                let model = PictureModel.init()
                model.picture_url = (pic as! Picture).picture_url!
                model.picture_id = Int((pic as! Picture).picture_id)
                model.detail_url = (pic as! Picture).detail_url!
                model.title = (pic as! Picture).title!
                array.append(model)
            }
            return array
        }
    }
}
