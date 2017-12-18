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
    static var _language:String = EN
    class var language:String {
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
    
    class var bundle:Bundle {
        get {
            let path = Bundle.main.path(forResource: LocalizedLanguageTool.language, ofType: "lproj")
            let cbundle = Bundle.init(path: path!)
            return cbundle!
        }
    }
    
    func getString(forKey:String,table:String = "content") -> String {
        return NSLocalizedString(forKey, tableName: table, bundle: LocalizedLanguageTool.bundle, value: "", comment: "")
    }
}
