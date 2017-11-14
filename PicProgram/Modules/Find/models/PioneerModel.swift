//
//  PioneerModel.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PioneerModel: BaseObject {
    @objc var banner:Array<PaintModel> = Array()
    @objc var master_quote:MasterQuoteModel!
    @objc var classic_quote:Array<ClassicQuoteModel> = Array()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banner" {
            let array = value as! Array<[String:Any]>
            for item in array {
                let model = PaintModel.init(dict:item)
                banner.append(model)
            }
            
        }else if key == "master_quote" {
            master_quote = MasterQuoteModel.init(dict:value as! [String : Any])
        }else if key == "classic_quote" {
            let array = value as! Array<[String:Any]>
            for item in array {
                let model = ClassicQuoteModel.init(dict:item)
                classic_quote.append(model)
            }
            
        }
    }
}
