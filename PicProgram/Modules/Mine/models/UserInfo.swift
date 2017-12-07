//
//  UserInfo.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/20.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

let User_uin = "uin"
let User_token = "token"

class UserInfo: UserModel {
    
    //单例
    class var user: UserInfo {
        struct Singleton {
            static let instance = UserInfo()
        }
        return Singleton.instance
    }

    func checkUserLogin() -> Bool {
        if self.uin == 100000 {
            return false
        }
        return true
    }
    
    //登录数据本地化
    func saveToUserDefaults() {
        UserDefaults.standard.set(uin, forKey: User_uin)
        UserDefaults.standard.set(token, forKey: User_token)
        UserDefaults.standard.synchronize()
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        self.saveToUserDefaults()
    }
    
    //读取本地化数据
    func readUserDefaults() {
        self.uin = UserDefaults.standard.value(forKey: User_uin) != nil ? (UserDefaults.standard.value(forKey: User_uin) as! Int) : 100000
        self.token = UserDefaults.standard.value(forKey: User_token) == nil ? "" : (UserDefaults.standard.value(forKey: User_token) as! String)

    }
    
    //更新当前用户信息
    func updateUserInfo(callback:(()->())? = nil) {
        network.requestData(.user_info, params: nil, finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                UserInfo.user.setValuesForKeys(result["user_info"] as! [String : Any])
                UserInfo.user.saveToUserDefaults()
                callback!()
            }
            }, nil)
    }
    //退出登录
    func localLogout() {
        UserDefaults.standard.removeObject(forKey: User_uin)
        UserDefaults.standard.removeObject(forKey: User_token)
        UserDefaults.standard.synchronize()
    }
    
    @objc var uin: Int = 0
    @objc var token:String = ""
    @objc var head_url:String = ""
    @objc var background:String = ""
    @objc var nick_name:String = ""
    @objc var gender:Int = 0
    @objc var birth_year:Int = 0
    @objc var birth_month:Int = 0
    @objc var birth_day:Int = 0
    @objc var region:String = ""
    @objc var personal_profile:String = ""
    @objc var email_verified:String = ""
}
