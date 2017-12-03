//
//  LogOutView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/12.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//`

import UIKit

class LogOutView: BaseScrollView {
    open weak var cDelegate:MineViewProtocol!
    var headerButton:UIButton!
    override func buildUI() {
        let headerBackView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 230))
        headerBackView.image = UIImage.init(named: "headerBackground")
        headerBackView.isUserInteractionEnabled = true
        self.addSubview(headerBackView)
        
        let settingButton = UIButton.init(frame: CGRect.init(x: 10, y: StatusBarHeight, width: 44, height: 44))
        settingButton.setImage(#imageLiteral(resourceName: "08wode_shebeiguanli_shezhi"), for: .normal)
        headerBackView.addSubview(settingButton)
        settingButton.tag = 10
        settingButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

        let showButton = UIButton.init(frame: CGRect.init(x: self.width - 54, y: settingButton.y, width: 44, height: 44))
        showButton.setImage(#imageLiteral(resourceName: "08wode_shebeiguanli"), for: .normal)
        showButton.tag = 12
        headerBackView.addSubview(showButton)
        showButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

        headerButton = UIButton.init(frame: CGRect.init(x: (self.width - 71)/2, y: (headerBackView.height - 71)/2, width: 71, height: 71))
        headerButton.setImage(#imageLiteral(resourceName: "08weidenglu_yonghu_touxiang"), for: .normal)
        headerButton.tag = 20
        headerButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        headerBackView.addSubview(headerButton)
        
        let statusButton = UIButton.init(frame: CGRect.init(x: headerButton.x, y: headerButton.bottom + 15, width: headerButton.width, height: 20))
        statusButton.setTitleColor(xsColor_main_text, for: .normal)
        statusButton.setTitle("未登录", for: .normal)
        statusButton.tag = 21
        statusButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        headerBackView.addSubview(statusButton)
        
        let shebeiTitleView = UIButton.init(frame: CGRect.init(x: 0, y: headerBackView.bottom, width: self.width, height: 41))
        shebeiTitleView.isUserInteractionEnabled = false
        shebeiTitleView.setTitle("设备", for: .normal)
        shebeiTitleView.titleLabel?.font = xsFont(15)
        shebeiTitleView.setTitleColor(xsColor_main_text_blue, for: .normal)
        self.addSubview(shebeiTitleView)
        
        let lineImageView = UIImageView.init(image: #imageLiteral(resourceName: "jianbiantiao"))
        lineImageView.frame = CGRect.init(x: 0, y: shebeiTitleView.bottom, width: shebeiTitleView.width, height: 3)
        self.addSubview(lineImageView)
        
        let noDeviceView = UIImageView.init(frame: CGRect.init(x: (self.width - 267)/2, y: shebeiTitleView.bottom + 29, width: 267, height: 175))
        noDeviceView.image = #imageLiteral(resourceName: "08wode_shebeikuang")
        self.addSubview(noDeviceView)
        
        let noDeviceTitleView = UILabel.init(frame: CGRect.init(x: 0, y: (noDeviceView.height - 20)/2 - 15, width: noDeviceView.width, height: 20))
        noDeviceTitleView.text = "暂无绑定设备"
        noDeviceTitleView.textAlignment = .center
        noDeviceTitleView.font = xsFont(12)
        noDeviceTitleView.textColor = xsColor_main_text_blue
        noDeviceView.addSubview(noDeviceTitleView)
        
        let titles = ["添加设备","Wi-fi配置"]
        let images = [#imageLiteral(resourceName: "08wode_tianjiashebei"),#imageLiteral(resourceName: "08wode_wifipeizhi")]
        for i in 0 ..< titles.count {
            let x = (self.width)/2 - 64 + 84 * CGFloat(i)
            let button = UIButton.init(frame: CGRect.init(x: x, y: noDeviceView.bottom + 20, width: 40, height: 40))
            button.tag = 30+i
            button.setImage(images[i], for: .normal)
            self.addSubview(button)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            
            let label = UILabel.init(frame: CGRect.init(x: button.x - 10, y: button.bottom + 10, width: button.width + 20, height: 15))
            label.font = xsFont(12)
            label.textColor = xsColor_main_text_blue
            label.text = titles[i]
            label.textAlignment = .center
            self.addSubview(label)
        }
        
        self.contentSize = CGSize.init(width: self.width, height: noDeviceView.bottom + 120+49)
    }

    
    
    @objc func buttonAction(_ sender: UIButton) {
        if sender.tag == 10 {
            cDelegate.settingDidSelected!()
        }else if sender.tag == 20 {
            cDelegate.headerDidSelected!()
        }
    }
}

@objc protocol MineViewProtocol:NSObjectProtocol {
    @objc optional func headerDidSelected()
    @objc optional func settingDidSelected()
}
