//
//  LogOutView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/12.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//`

import UIKit

class DeviceManageView: UIView {
    open weak var cDelegate:MineViewProtocol!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceManageButton: UIButton!
    @IBOutlet weak var wifiButton: UIButton!
    
    @IBOutlet weak var addDeviceButton: UIButton!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 10 {
            cDelegate.deviceManageSelected!()
        }else if sender.tag == 20 {
            cDelegate.addDeviceSelected!()
        }else if sender.tag == 21 {
            cDelegate.wifiManageSelected!()
        }else if sender.tag == 30 {
            cDelegate.backSelectd!()
        }
    }

}

@objc protocol MineViewProtocol:NSObjectProtocol {
    @objc optional func headerDidSelected()
    @objc optional func settingDidSelected()
    @objc optional func deviceManageSelected()
    @objc optional func addDeviceSelected()
    @objc optional func wifiManageSelected()
    @objc optional func backSelectd()
    @objc optional func scanCode(result: String)
    @objc optional func removeDevice(view:UIView,deviceIndex row : Int)
    @objc optional func promiseBindDevice(view:UIView,deviceIndex row : Int)
    @objc optional func denyBindDevice(view:UIView,deviceIndex row : Int)
}
