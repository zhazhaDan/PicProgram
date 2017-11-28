//
//  LoginView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/11.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

enum LoginThirdAppType:Int {
    case login_wxchat = 0
    case login_sinawb
    case login_twitter
    case login_facebook
}

class LoginView: BaseScrollView,UITextFieldDelegate{
    var phone_textfield: UITextField!
    var code_textfield: UITextField!
    var viewHeight:CGFloat = 0
    open weak var c_delegate:CustomViewProtocol!
    
   
    override func buildUI() {
        let loginImageView = UIImageView.init(frame: CGRect.init(x: (self.width - 223)/2, y: 0, width: 223, height: 177))
        loginImageView.image = UIImage.init(named: "logo")
        loginImageView.contentMode = .scaleAspectFit
        self.addSubview(loginImageView)
        
        let inputView = UIView.init(frame: CGRect.init(x: 0, y: loginImageView.bottom, width: self.width, height: 120))
        self.addSubview(inputView)
        viewHeight = inputView.bottom
        //手机号输入

        phone_textfield = UITextField.init(frame:CGRect.init(x: 42, y: 0, width: inputView.width - 84, height: 50))
        phone_textfield.font = xsFont(15)
//        phone_textfield.placeholder = "请输入用户名/邮箱号"
        phone_textfield.keyboardType = .numberPad
        phone_textfield.textColor = xsColor_main_text
        phone_textfield.delegate = self
        phone_textfield.leftViewMode = .always
        phone_textfield.attributedPlaceholder = NSAttributedString.init(string: "请输入用户名/邮箱号", attributes: [NSAttributedStringKey.foregroundColor:xsColor_main_text])
        inputView.addSubview(phone_textfield)
        
        let phoneLeftView = UIImageView.init(image: UIImage.init(named: "youxiang_icon"))
        phone_textfield.leftView = phoneLeftView
        
        let phone_line = UIView.init(frame:CGRect.init(x: 0, y: phone_textfield.bottom - 1, width: inputView.width - 84, height: 1))
        phone_line.backgroundColor = xsColor_line_grey
        phone_textfield.addSubview(phone_line)
        
        code_textfield = UITextField.init(frame:CGRect.init(x: 42, y: phone_textfield.bottom, width: inputView.width - 84, height: 50))
        code_textfield.font = xsFont(15)
//        code_textfield.placeholder = "请输入密码"
        code_textfield.textColor = xsColor_main_text
        code_textfield.delegate = self
        code_textfield.keyboardType = .numberPad
        code_textfield.leftViewMode = .always
        code_textfield.attributedPlaceholder = NSAttributedString.init(string: "请输入密码", attributes: [NSAttributedStringKey.foregroundColor:xsColor_main_text])

        inputView.addSubview(code_textfield)
        
        let codeLeftView = UIImageView.init(image: UIImage.init(named: "mima_icon"))
        code_textfield.leftView = codeLeftView
        
        let code_line = UIView.init(frame:CGRect.init(x: 0, y: phone_textfield.bottom-1, width: inputView.width - 84, height: 1))
        code_line.backgroundColor = xsColor_line_grey
        code_textfield.addSubview(code_line)
        
        viewHeight = code_textfield.bottom
        let buttonTitles = ["登录","注册","稍后注册"]
        for i in 0 ..< 3 {
            let button = UIButton.init(frame: CGRect.init(x: 42, y: inputView.bottom + CGFloat(56*i), width: self.width - 84, height: 32))
            button.setTitle(buttonTitles[i], for: .normal)
            button.setTitleColor(xsColor_main_text, for: .normal)
            button.setTitleColor(xsColor_main_white, for: .selected)
            button.setTitleColor(xsColor_main_white, for: .highlighted)
            button.setBackgroundImage(UIImage.init(named: "00dengluzhuce_denglu_dianjianniu"), for: .selected)
            button.setBackgroundImage(UIImage.init(named: "00dengluzhuce_denglu_dianjianniu"), for: .highlighted)
            button.setBackgroundImage(UIImage.init(named: "00dengluzhuce_zhuce_weidianjianniu"), for: .normal)
            button.tag = 10 + i
            self.addSubview(button)
            if i == 0 {
                button.isSelected = true
            }else if i == 2 {
                viewHeight = button.bottom
            }
            button.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        }
        var icons = Array<String>()
        var titles = Array<String>()
        var types = Array<LoginThirdAppType>()
        icons = ["Facebookdenglu","twitterdenglu","weibodenglu_icon","weixindenglu_icon"]
        titles = ["Facebook","Twitter","微信登录","微博登录"]
        types = [.login_facebook,.login_twitter,.login_wxchat,.login_sinawb]
        for i in 0 ..< icons.count {
            let left = (self.width - CGFloat(icons.count * Int(57 * iPhoneScale) - 17))/2.0
            let imageButton = UIButton()
            imageButton.frame = CGRect.init(x: left + CGFloat(i) * 57 * iPhoneScale, y: viewHeight + 10, width: 40*iPhoneScale, height: 40*iPhoneScale)
            imageButton.layer.cornerRadius = 20*iPhoneScale
            imageButton.layer.masksToBounds = true
            imageButton.titleLabel?.font = xsFont(17)
            
            imageButton.setImage(UIImage.init(named: icons[i]), for: .normal)
            imageButton.addTarget(self, action: #selector(shareToThirdApps(_:)), for: .touchUpInside)
            imageButton.tag = 20 + types[i].rawValue
            self.addSubview(imageButton)
            
            let label = UILabel.initializeLabel(CGRect.init(x: imageButton.x, y: imageButton.bottom, width: imageButton.width, height: 20), font: 9, textColor: xsColor_main_text, textAlignment: .center)
            label.text = titles[i]
            self.addSubview(label)
            if i == icons.count - 1 {
                viewHeight = label.bottom
            }
        }
        self.contentSize = CGSize.init(width: self.width, height: viewHeight + 50)
    }
    
    @objc func buttonAction(_ sender:UIButton) {
        for i in 0 ..< 3 {
            let btn:UIButton = self.viewWithTag(10+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
                self.c_delegate.listDidSelected!(view: self, at: sender.tag, 0)
            }else {
                btn.isSelected = false
            }
        }
    }
    
    @objc func shareToThirdApps(_ sender:UIButton) {
        
        self.c_delegate.listDidSelected!(view: self, at: sender.tag, 0)
    }
    
}
