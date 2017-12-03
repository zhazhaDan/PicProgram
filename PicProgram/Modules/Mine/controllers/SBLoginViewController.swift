//
//  SBLoginViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class SBLoginViewController: BaseViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var mainScrollView: UIScrollView!
    @IBAction func loginAction(_ sender: Any) {
        requestData()
    }
    @IBAction func registAction(_ sender: Any) {
        let registVC = RegisterViewController.init(nibName: "RegisterViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(registVC, animated: true)
    }
    
    @IBAction func holdRegistAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func thirdLoginAction(_ sender: Any) {
    }
    
    @IBAction func forgetPassAction(_ sender: Any) {
        let forgetVC = FindPassViewController.init(nibName: "FindPassViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.customNavigationView()
    }

    
    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        self.title = LocalizedLanguageTool().getString(forKey: "Art Works")
    }
    
    
    @IBAction func tapRegistKeyboardAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                HUDTool.show(.text, text: "登录成功", delay: 0.6, view: (self?.view)!, complete: nil)
                UserInfo.user.setValuesForKeys(result)
                UserInfo.user.updateUserInfo()
//                self?.navigationController?.popToRootViewController(animated: true)
                self?.dismiss(animated: true, completion: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: (self?.view)!, complete: nil)
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
