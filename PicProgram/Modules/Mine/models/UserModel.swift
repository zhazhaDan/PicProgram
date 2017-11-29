//
//  UserModel.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/16.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class UserModel: BaseObject {
    @objc var phone:String = ""
    @objc var email:String = ""
    @objc var password:String = ""
    @objc var code:String = ""
    @objc var register_id:String {
        if phone.count > 0 {
            return phone
        }else if email.count > 0 {
            return email
        }
        return ""
    }
}
