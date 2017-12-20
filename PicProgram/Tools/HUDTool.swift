//
//  HUDManager.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/11.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit

/*:
 > # HUD工具类
 * type      LoadingType类型选择
 * text      文字显示
 * delay     延时关闭
 * view      展示view
 * complete  回调
 ---
 [git网址](https://github.com/pkluz/PKHUD)
 */

enum LoadingType {
    case success    //成功
    case error      //错误  请求失败
    case loading    //loading 请求中
    case text       //纯文字提醒
    case custom     //自定义图片
    case hide
}

class HUDTool {
    open static func hide() {
        HUD.hide(animated: true, completion: nil)
    }
    open static func show(_ type:LoadingType, _ image:UIImage? = #imageLiteral(resourceName: "icons8-info"), text showText:String? = nil,delay:TimeInterval = 0.5,view inView:UIView,complete:(()->Void)? = nil){
        HUD.dimsBackground = false
        switch type {
        case .success:
            HUD.show(.labeledSuccess(title: showText, subtitle: nil), onView: inView)
            HUD.hide(afterDelay: delay, completion: { (ret) in
                if(ret && complete != nil) {
                    complete!()
                }
            })
        case .error:
            HUD.show(.labeledError(title: showText, subtitle: nil), onView: inView)
            HUD.hide(afterDelay: delay, completion: { (ret) in
                if(ret && complete != nil) {
                    complete!()
                }
            })
        case .text:
            HUD.flash(.label(showText), onView: inView, delay: delay, completion: { (ret) in
                if(ret && complete != nil) {
                    complete!()
                }
            })
        case .loading:
//            HUD.flash(.labeledProgress(title: nil, subtitle: showText), onView: UIApplication.shared.keyWindow, delay: delay, completion: {(ret) in
//                if(ret && complete != nil) {
//                    complete!()
//                }})
            HUD.flash(.rotatingImage(#imageLiteral(resourceName: "progress_circular")), onView: inView, delay: delay, completion: { (ret) in
                if(ret && complete != nil) {
                    complete!()
                }
            })
        case .custom:
            HUD.flash(.labeledImage(image: image, title: showText, subtitle: nil), onView: inView, delay: delay, completion: { (ret) in
                if(ret && complete != nil) {
                    complete!()
                }
            })
        default:
            HUD.hide(animated: true, completion: nil)
            
        }
    }
}
