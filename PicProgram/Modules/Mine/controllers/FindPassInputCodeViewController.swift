//
//  FindPassViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

enum LoginMethod {
    case login_regist
    case login_forgetPass
}

enum UserType {
    case User_type_email
    case User_type_phone
}

class FindPassInputCodeViewController: BaseViewController {
    @IBOutlet weak var codeTextfield: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    var userModel:UserModel!

    
    var method:LoginMethod = .login_regist
    var type:UserType = .User_type_email
    @IBAction func sendCodeAction(_ sender: Any) {
        switch method {
        case .login_regist:
            requestRegist()
        case .login_forgetPass:
            //测试代码
            let repassVC = ChangePassViewController.init(nibName: "ChangePassViewController", bundle: Bundle.main)
            repassVC.userModel = self.userModel
            self.navigationController?.pushViewController(repassVC, animated: true)
        }
    }
    @IBAction func resendCodeAction(_ sender: Any) {
        self.requestData()
    }
    
    func requestRegist() {
        var param = ["password":self.userModel.password,"verify_code":codeTextfield.text] as [String : Any]
        if self.userModel.phone.count > 0 {
            param["phone"] = self.userModel.phone
        }else if self.userModel.email.count > 0 {
            param["email"] = self.userModel.email
        }
        network.requestData(.user_register, params: param, finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0{
//                self?.navigationController?.popToRootViewController(animated: true)
                UserInfo.user.setValuesForKeys(result)
                UserInfo.user.updateUserInfo()
                self?.dismiss(animated: true, completion: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: (self?.view)!, complete: nil)
            }
        }, nil)
    }
    
    override func requestData() {
        //发送验证码
//        var str = userModel.email
        var hint = MRLanguage(forKey: "Verification Code To Your Email")
        if userModel.email.count == 0 {
//            str = userModel.phone
            hint = MRLanguage(forKey: "Verification Code To Your Phone")
        }
        network.requestData(.user_send_code, params: ["register_id":userModel.register_id], finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: hint, delay: 1, view: self.view, complete: {
                    let vc = FindPassInputCodeViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
            }
        }, nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == .User_type_email {
            hintLabel.text = MRLanguage(forKey: "Enter Email Verify Code")
        }else {
            hintLabel.text = MRLanguage(forKey: "Enter Phone Verify Code")
        }
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
