//
//  LocationLanguageTool.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/29.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

let CNS = "zh-Hans" //中文
let EN = "en" //英文
let LanguageKey = "language"
let LanguageChangedNotification = "LanguageChangedNotification"
class BaseBundle: NSObject {
    static var _language:String = EN
    class var language:String {
        set {
            _language = newValue
            Bundle.setCusLanguage(_language)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LanguageChangedNotification), object: nil)
            appDelegate.changeLanguage()
        }
        get {
            let lag = Bundle.getCusLanguage()
            if lag == nil {
                return CNS
            }
           return Bundle.getCusLanguage()
        }
    }
    
    class var bundle:Bundle {
        get {
            let path = Bundle.main.path(forResource: BaseBundle.language, ofType: "lproj")
            let cbundle = Bundle.init(path: path!)
            return cbundle!
        }
    }
    
    func getString(forKey:String,table:String = "content") -> String {
        return NSLocalizedString(forKey, tableName: table, bundle: BaseBundle.bundle, value: "", comment: "")
    }
}
