//
//  CustomAlert+UIAlertController.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/20.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit
class BaseAlertController:UIAlertController {
    open static func `init`(_ title:String,message:String?=nil,confirmText:String,_ cancelText:String? = "取消",subComplete:((Int)->Void)? = nil) -> BaseAlertController {
        let alertController = BaseAlertController.init(title: title, message: message, preferredStyle: .alert)
        let subAction = UIAlertAction.init(title: confirmText, style: .default) { (action) in
            if subComplete != nil {
                subComplete!(0)
            }
        }
        alertController.addAction(subAction)
        
        if cancelText != nil {
            let cancelAction = UIAlertAction.init(title: cancelText, style: .cancel){ (action) in
                if subComplete != nil {
                    subComplete!(1)
                }
            }
            alertController.addAction(cancelAction)
        }
        return alertController
    }
    static func textAlertController(_ text:String) -> BaseAlertController {
        let alert = BaseAlertController.init(text, message: nil, confirmText: "确定", nil, subComplete: nil)
//        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        return alert
    }
}
