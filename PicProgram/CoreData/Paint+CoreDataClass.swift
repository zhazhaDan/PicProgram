//
//  Paint+CoreDataClass.swift
//  
//
//  Created by 龚丹丹 on 2017/12/10.
//
//

import Foundation
import CoreData

enum PaintPropertyKey:String {
    case name = "paint_title"
    case id = "paint_id"
}
//enum PaintPredicateType {
//    case Name(key:PaintPropertyKey.name,value:Any)
//}

public class Paint: NSManagedObject {
    //NSPredicate
    class func fetchPaint(key: PaintPropertyKey, value: Any, create:Bool = true, painttype type:Int16 = 1) -> Paint? {//1是本地画单 3是历史浏览
        let fetchRequest: NSFetchRequest<Paint> = Paint.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        var newValue = value
        if value is String {
            newValue = "\"\(value as! String)\""
        }
        let predicate = NSPredicate.init(format: "(\(key.rawValue)==\(newValue))AND(paint_type==\(type))", argumentArray: nil)
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
        if create {
            let entity = NSEntityDescription.entity(forEntityName: "Paint", in: appDelegate.managedObjectContext) as! NSEntityDescription
            let paint = NSManagedObject.init(entity: entity, insertInto: appDelegate.managedObjectContext) as! Paint
            paint.setValue(value, forKey: key.rawValue)
            paint.paint_type = type
            return paint
        }else {
            return nil
        }
       
    }
    
    @nonobjc public class func fetchAllLocalPaint() -> Array<Paint>? {
        let fetchRequest: NSFetchRequest<Paint> = Paint.fetchRequest()
        let predicate = NSPredicate.init(format: "paint_type==1", argumentArray: nil)
        fetchRequest.predicate = predicate

        do {
            let fetchedResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                return results as! [Paint]
            }
            
        } catch  {
            fatalError("获取失败")
        }
        return nil
    }
    
    //NSPredicate
    @nonobjc public class func fetchAllPaints(forPaintType type : Int) -> Array<Paint>? {
        let fetchRequest: NSFetchRequest<Paint> = Paint.fetchRequest()
//        fetchRequest.fetchBatchSize = 1
        let predicate = NSPredicate.init(format: "paint_type==\(type)", argumentArray: nil)
        fetchRequest.predicate = predicate
        do {
            let fetchedResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                return results as! Array<Paint>
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
                let picture = pic as! Picture
                let model = PictureModel.init()
                let properties = ["picture_id","picture_type","title","time","size","detail","picture_url","detail_url","picture_content"]
                for i in 0 ..< properties.count {
                    if picture.value(forKey: properties[i]) != nil {
                        model.setValue(picture.value(forKey: properties[i]), forKey: properties[i])
                    }
                }
                array.append(model)
            }
            return array
        }
    }
}
