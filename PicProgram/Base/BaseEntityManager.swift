//
//  BaseEntityManager.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/18.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import CoreData

class BaseEntityManager: BaseObject {
    
    static func saveDataModels(values:Array<[String:Any]>,entity name:String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        var context = NSManagedObjectContext()
        if #available(iOS 10.0, *) {
            context = app.persistentContainer.viewContext
            
        } else {
            context = app.managedObjectContext
            // Fallback on earlier versions
        }
        for item in values {
            let model = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! BaseObject
            model.setValuesForKeys(item)
        }
        do {
            try context.save()
            print("保存成功")
        }catch {
            fatalError("不能保存\(error)")
        }
    }
    
    
    static func deleteDataModel(obj:NSManagedObject) {
        let app = UIApplication.shared.delegate as! AppDelegate
        var context = NSManagedObjectContext()
        if #available(iOS 10.0, *) {
            context = app.persistentContainer.viewContext
            
        } else {
            context = app.managedObjectContext
            // Fallback on earlier versions
        }
        context.delete(obj)
        do {
            try context.save()
            print("保存成功")
        }catch {
            fatalError("不能保存\(error)")
        }
    }
}
