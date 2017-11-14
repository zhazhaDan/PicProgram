//
//  FindTodayRecomModel.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class FindTodayRecomModel: BaseObject {
    @objc var banner:Array<PaintModel> = Array()
    @objc var new_arry:Array<PaintModel> = Array()
    @objc var hot_arry:Array<PaintModel> = Array()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banner" {
            let array = value as! Array<[String:Any]>
            for item in array {
                let model = PaintModel.init(dict:item)
                banner.append(model)
            }

        }else if key == "new_arry" {
            let array = value as! Array<[String:Any]>
            for item in array {
                let model = PaintModel.init(dict:item)
                new_arry.append(model)
            }
            
        }else if key == "hot_arry" {
            let array = value as! Array<[String:Any]>
            for item in array {
                let model = PaintModel.init(dict:item)
                hot_arry.append(model)
            }
            
        }
    }
}
