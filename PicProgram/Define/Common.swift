//
//  Common.swift
//  Capsule_iOS
//
//  Created by 龚丹丹 on 2017/7/6.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

//统一通知名称
let NotificationName_LocalPaintCreateSuccessful = "NotificationName_LocalPaintCreateSuccessful"

//统一常量定义

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let service_number = "400-688-9960"

let infoDictionary = Bundle.main.infoDictionary!
let appDisplayName = infoDictionary["CFBundleDisplayName"] as! String//程序名称
let majorVersion = infoDictionary ["CFBundleShortVersionString"] as! String//主程序版本号
let minorVersion = infoDictionary ["CFBundleVersion"] as! String//版本号（内部标示）

#if DEBUG
#else
#endif
/*:
 > # IMPORTANT:颜色
十六进制颜色转换
*  color: 十六进制 颜色字符串 例如：999999
*  alpha: 透明度 默认1
*  Returns: 返回颜色实例
*/
func xsColor(_ color:String,alpha:Float = 1) -> UIColor {
    let scanner = Scanner.init(string: color)
    var hexNum:UInt32 = 0
    if (scanner.scanHexInt32(&hexNum)){
        let r = Float((hexNum >> 16) & 0xFF)/255
        let g = Float((hexNum >> 8) & 0xFF)/255
        let b = Float(hexNum & 0xFF)/255
        return UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(alpha))
    }
    return UIColor.white
}

//通用色值
let xsColor_title_normal = xsColor("adadad")
let xsColor_title_select = xsColor("4a4a4a")
let xsColor_main_blue = xsColor("189df9")
let xsColor_main_red = xsColor("fe393d")
let xsColor_main_white = xsColor("ffffff")
let xsColor_main_black = xsColor("000000")
let xsColor_main_yellow = xsColor("c49255")
let xsColor_line_grey = xsColor("ededed")
let xsColor_line_lightgrey = xsColor("f2f2f2")
let xsColor_mine_back = xsColor("edf0f5")
let xsColor_selected_grey = xsColor("e2e2e2")
let xsColor_placeholder_grey = xsColor("9f9f9f")
let xsColor_text_black = xsColor("333333")
let xsColor_text_lightblack = xsColor("666666")
let xsColor_text_title = xsColor("5c5c5c")
let xsColor_text_holder = xsColor("404040")
let xsColor_main_background = xsColor("f0f0f0")
let xsColor_main_text = xsColor("cdb291")
let xsColor_main_text_blue = xsColor("2b5f99")
let xsColor_button_highlighted = xsColor("000000",alpha: 0.1)
/*:
 > # IMPORTANT:字体字号
 *  size: 字号 浮点型
 *  family: 字体
 *  Returns: 返回字体实例
 */
func xsFont(_ size: CGFloat, family:String = "FZSKBXKJW--GB1-0") -> UIFont {
    return UIFont.init(name: family, size: size*CGFloat(fontScale))!
//    return UIFont.systemFont(ofSize: size*CGFloat(fontScale))
}

func xsBoldFont(_ size:CGFloat, family:String = "FZSKBXKJW--GB1-0") -> UIFont {
    
    return UIFont.init(name: family, size: size*CGFloat(fontScale))!

//    return UIFont.boldSystemFont(ofSize: size*CGFloat(fontScale))
}

//语言
func MRLanguage(forKey key:String) -> String {
    return LocalizedLanguageTool().getString(forKey: key)
}

/**
 * 打电话
 *callNumber： 拨号号码，默认公司客服号
 */
func xsCall(callNumber:String = service_number) {
    DispatchQueue.main.async {
        if #available(iOS 10.2, *){
            UIApplication.shared.open(URL.init(string: "tel://\(callNumber)")!, options: [:], completionHandler: nil)
        }else {
            UIApplication.shared.openURL(URL.init(string: "tel://\(callNumber)")!)
        }
    }
}

