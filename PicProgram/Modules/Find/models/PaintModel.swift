//
//  PaintModel.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PaintModel: BaseObject {
    @objc var paint_id :Int = 0
    @objc var flag :Int = 0 // 1 收藏  2未收藏
    @objc var title_url:String = ""
    @objc var paint_title:String = ""
    @objc var paint_detail :String = ""
    @objc var read_num:Int = 0
    @objc var love_num:Int = 0
    @objc var collect_num:Int = 0
    @objc var picture_num:Int = 0
    @objc var picture_arry:[PictureModel] = []
    @objc var picture_H:[PictureModel] = []
    @objc var picture_S:[PictureModel] = []

    //作者信息
    @objc var authro_id :Int = 0
    @objc var img_url:String = ""
    @objc var authro_name :String = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "picture_info" {
            let array = value as! Array<[String:Any]>
            for item in array {
                let model = PictureModel.init(dict: item)
                picture_arry.append(model)
                if model.picture_type == 1 {
                    picture_H.append(model)
                }else if model.picture_type == 2 {
                    picture_S.append(model)
                }
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

class PictureModel: BaseObject {
    @objc var picture_id :Int = 0
    @objc var picture_type:Int = 0
    @objc var title:String = ""
    @objc var time:String = ""
    @objc var size:String = ""
    @objc var detail:String = ""
    @objc var picture_url:String = ""
    @objc var picture_content :String = ""
}

class AutoModel: BaseObject {
    @objc var authro_id :Int = 0
    @objc var paint_id:Int = 0
    @objc var img_url:String = ""
    @objc var authro_name :String = ""
}
