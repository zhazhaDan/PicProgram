//
//  LocationLanguageTool.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/29.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

let CNS = "zh-Hans"
let EN = "en"
let LanguageKey = "language"

class LocalizedLanguageTool: NSObject {
    var _language:String = EN
    var language:String {
        set {
            _language = newValue
            UserDefaults.standard.set(newValue, forKey: LanguageKey)
            UserDefaults.standard.synchronize()
        }
        get {
            if UserDefaults.standard.value(forKey: LanguageKey) != nil {
                _language = UserDefaults.standard.value(forKey: LanguageKey) as! String
            }
            return _language
        }
    }
    
    func getString(forKey:String,table:String = "content") -> String {
        let path = Bundle.main.path(forResource: self.language, ofType: "lproj")
        let bundle = Bundle.init(path: path!)
        return NSLocalizedString(forKey, tableName: table, bundle: bundle!, value: "", comment: "")
    }
}
