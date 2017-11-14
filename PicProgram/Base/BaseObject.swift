//
//  BaseObject.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BaseObject: NSObject {
    override func setNilValueForKey(_ key: String) {
        //防止崩溃
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override init() {
        super.init()
    }
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
  
}
