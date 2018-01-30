//
//  CustomAlert+UIAlertController.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/20.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit
class BaseAlertController:UIView {
    
    var backView:UIView = UIView()
    var titleLabel:UILabel = UILabel()
    var contentLabel:UILabel = UILabel()
    var subButton:UIButton!
    var cancelButton:UIButton!
    var callBackBlock:((Int)->Void)!
    open static func inits(_ title:String,message:String?=nil,confirmText:String,_ cancelText:String? = "取消",_ selectedIndex:Int = 0,subComplete:((Int)->Void)? = nil) -> BaseAlertController {
        let alertController = BaseAlertController()
        alertController.buildUI(title, message: message, confirmText: confirmText, cancelText,selectedIndex,subComplete: subComplete)
        UIApplication.shared.keyWindow?.addSubview(alertController)
        return alertController
    }
    func buildUI(_ title:String,message:String?=nil,confirmText:String,_ cancelText:String? = "取消",_ selectedIndex:Int = 0,subComplete:((Int)->Void)? = nil) {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = xsColor("000000", alpha: 0.6)
        backView.frame = CGRect.init(x: 0, y: 0, width: (SCREEN_WIDTH - 48), height: 167)
        backView.center = self.center
        backView.backgroundColor = xsColor_main_white
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
        self.addSubview(backView)
        titleLabel = UILabel.initializeLabel(CGRect.init(x: 15, y: 29, width: backView.width - 30, height: 20), font: 15, textColor: xsColor_main_blue, textAlignment: .center)
        titleLabel.text = title
        if title.count == 0 {
            titleLabel.height = 0
        }
        backView.addSubview(titleLabel)
        
        contentLabel = UILabel.initializeLabel(CGRect.init(x: titleLabel.x, y: titleLabel.bottom, width: titleLabel.width, height: 40), font: 15, textColor: xsColor_main_blue, textAlignment: .center)
        contentLabel.numberOfLines = 0
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.text = message
        backView.addSubview(contentLabel)
        
        subButton = UIButton.init(frame: CGRect.init(x: 25, y: backView.height - 42 - 26, width: 125, height: 42))
        subButton.setBackgroundImage(#imageLiteral(resourceName: "08se_shezhi_tishianniu"), for: .selected)
        subButton.setBackgroundImage(#imageLiteral(resourceName: "08se_shezhi_tishianniu"), for: .highlighted)
        subButton.setBackgroundImage(#imageLiteral(resourceName: "08se_shezhi_tishianniu_weixuan"), for: .normal)
        subButton.titleLabel?.font = xsFont(15)
        subButton.setTitleColor(xsColor_main_white, for: .selected)
        subButton.setTitleColor(xsColor_main_white, for: .highlighted)
        subButton.setTitleColor(xsColor_main_yellow, for: .normal)
        subButton.setTitle(confirmText, for: .normal)
        if selectedIndex == 0 {
            subButton.isSelected = true
        }
        subButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        backView.addSubview(subButton)
        
        if cancelText == nil || cancelText?.count == 0 {
            subButton.center.x = backView.width / 2
        }else {
            cancelButton = UIButton.init(frame: CGRect.init(x: backView.width - 125 - 25, y: subButton.y, width: 125, height: 42))
            cancelButton.setBackgroundImage(#imageLiteral(resourceName: "08se_shezhi_tishianniu"), for: .selected)
            cancelButton.setBackgroundImage(#imageLiteral(resourceName: "08se_shezhi_tishianniu"), for: .highlighted)
            cancelButton.setBackgroundImage(#imageLiteral(resourceName: "08se_shezhi_tishianniu_weixuan"), for: .normal)
            cancelButton.titleLabel?.font = xsFont(15)
            cancelButton.setTitleColor(xsColor_main_white, for: .selected)
            cancelButton.setTitleColor(xsColor_main_white, for: .highlighted)
            cancelButton.setTitleColor(xsColor_main_yellow, for: .normal)
            cancelButton.setTitle(cancelText, for: .normal)
            cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            backView.addSubview(cancelButton)
            if selectedIndex == 1 {
                cancelButton.isSelected = true
            }
        
        }
        
        callBackBlock = { index in
            if subComplete != nil {
                subComplete!(index)
            }
        }
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(removeAction))
        self.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func removeAction() {
        self.removeFromSuperview()
    }
    
    @objc func cancelAction() {
        callBackBlock(1)
        self.removeFromSuperview()
    }
    
    @objc func submitAction() {
        callBackBlock(0)
        self.removeFromSuperview()
    }
    
    
}

