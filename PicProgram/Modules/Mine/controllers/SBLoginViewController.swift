//
//  SBLoginViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class SBLoginViewController: BaseViewController,WXApiDelegate,WeiboSDKDelegate {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var mainScrollView: UIScrollView!
    var userModel:UserModel = UserModel()
    @IBAction func loginAction(_ sender: UIButton) {
        updateButtonStatus(sender: sender)
        requestData()
    }
    @IBAction func registAction(_ sender: UIButton) {
        let registVC = UserProtocolViewController.init(nibName: "UserProtocolViewController", bundle: Bundle.main)
        registVC.userModel = self.userModel
        self.navigationController?.pushViewController(registVC, animated: true)
        updateButtonStatus(sender: sender)
    }
    
    @IBAction func holdRegistAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        updateButtonStatus(sender: sender)
    }
    
    @IBAction func thirdLoginAction(_ sender: UIButton) {
        if sender.tag == 10 {
            //微信登录
            let req = SendAuthReq.init()
            req.scope = "snsapi_userinfo"
            req.state = "wechat_sdk_demo"
            req.openID = ""
            WXApi.sendAuthReq(req, viewController: self, delegate: self)
        }else if sender.tag == 11 {
            let req = WBAuthorizeRequest.init()
            req.redirectURI = "https://api.weibo.com/oauth2/default.html"
            req.scope = "all"
            WeiboSDK.send(req)
        }
    }

    
    func onResp(_ resp: BaseResp!) {
        if resp.errCode < 0 {
            HUDTool.show(.text, nil, text: MRLanguage(forKey: "Auth Failed"), delay: 0.5, view: self.view, complete: nil)
            
        }else {
            if resp is SendAuthResp {
                let response = resp as! SendAuthResp
               thirdLogin(code: response.code as! String)
            }
           
        }
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        /*
         WeiboSDKResponseStatusCodeSuccess = 0,
         WeiboSDKResponseStatusCodeUserCancel = -1,
         WeiboSDKResponseStatusCodeSentFail = -2,
         WeiboSDKResponseStatusCodeAuthDeny = -3,
         WeiboSDKResponseStatusCodeUserCancelInstall = -4,
         WeiboSDKResponseStatusCodeUnsupport = -99,
         WeiboSDKResponseStatusCodeUnknown = -100,
         */
        
        if response.statusCode == .userCancel {
            HUDTool.show(.text, nil, text: MRLanguage(forKey: "user cancel"), delay: 1, view: self.view, complete: nil)
        }else if response.statusCode == .success{
            if response.isKind(of: WBAuthorizeResponse.self)  {
                let autoRep = response as! WBAuthorizeResponse
                thirdLogin(code: autoRep.accessToken)
            }
        }else{
            HUDTool.show(.text, nil, text: MRLanguage(forKey: "user cancel"), delay: 1, view: self.view, complete: nil)
        }
        
        
    }
    
    func thirdLogin(code:String) {
        network.requestData(.user_third_login, params: ["register_type":2,"auth_token":code], finishedCallback: { [weak self] (result) in
            if result["ret"] as! Int == 0{
                HUDTool.show(.text, text: MRLanguage(forKey: "Sign in successful"), delay: 0.6, view: (self?.view)!, complete: nil)
                UserInfo.user.setValuesForKeys(result)
                UserInfo.user.updateUserInfo()
                if UserInfo.user.client_id != nil && UserInfo.user.client_id?.count as! Int > 0 {
                    UserInfo.user.updateIgetuiClient(clientId: UserInfo.user.client_id!)
                }
                //                self?.navigationController?.popToRootViewController(animated: true)
                self?.dismiss(animated: true, completion: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: (self?.view)!, complete: nil)
            }
            }, nil)
        
    }
    
    
    func updateButtonStatus(sender:UIButton) {
        for i in 0 ..< 3 {
            let btn = self.view.viewWithTag(10+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func forgetPassAction(_ sender: Any) {
        let forgetVC = FindPassViewController.init(nibName: "FindPassViewController", bundle: Bundle.main)
        forgetVC.userModel = self.userModel
        forgetVC.title = MRLanguage(forKey: "Find Password")
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.customNavigationView()
    }

    
    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue,NSAttributedStringKey.font:xsFont(17)]
        self.title = MRLanguage(forKey: "Art Works")
    }
    
    
    @IBAction func tapRegistKeyboardAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainScrollView.contentSize = CGSize.init(width: mainScrollView.width, height: label.bottom + 44)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func requestData() {
        network.requestData(.user_login, params: ["register_id":emailTextfield.text as! String,"password":passTextfield.text as! String], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0{
                HUDTool.show(.text, text: MRLanguage(forKey: "Sign in successful"), delay: 0.6, view: appDelegate.window!, complete: nil)
                UserInfo.user.setValuesForKeys(result)
                UserInfo.user.updateUserInfo()
                if UserInfo.user.client_id != nil && UserInfo.user.client_id?.count as! Int > 0 {
                    UserInfo.user.updateIgetuiClient(clientId: UserInfo.user.client_id!)
                }
//                self?.navigationController?.popToRootViewController(animated: true)
                self?.dismiss(animated: true, completion: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: appDelegate.window!, complete: nil)
            }
        }, nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
