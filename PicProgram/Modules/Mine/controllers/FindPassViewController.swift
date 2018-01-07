//
//  FindPassViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class FindPassViewController: BaseViewController {
    var userModel:UserModel!

    @IBOutlet weak var emailTextfield: UITextField!
    @IBAction func sendCodeAction(_ sender: Any) {
        var hint = MRLanguage(forKey: "Verification Code To Your Phone")
        if emailTextfield.text?.hasSuffix("@") == true {
            hint = MRLanguage(forKey: "Verification Code To Your Email")
            userModel.email = self.emailTextfield.text!
        }else {
            hint = MRLanguage(forKey: "Verification Code To Your Phone")
            userModel.email = self.emailTextfield.text!        }
        //发送验证码
        HUDTool.show(.loading, view: (self.navigationController?.view)!)
        network.requestData(.user_send_code, params: ["register_id":emailTextfield.text], finishedCallback: { (result) in
            HUDTool.hide()
            if result["ret"] as! Int == 0 {
                HUDTool.show(.custom, text: hint , delay: 0.8, view: (self.navigationController?.view)!, complete: {
                   
                })
                let vc = FindPassInputCodeViewController()
                vc.method = .login_forgetPass
                vc.userModel = self.userModel
                vc.type = (self.emailTextfield.text?.hasSuffix("@") == true ? .User_type_email : .User_type_phone)
                vc.title = MRLanguage(forKey: "Find Password")
                vc.userModel = self.userModel
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
            }
        }, nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.userModel.register_id != nil {
            self.emailTextfield.text = self.userModel.register_id
        }
        // Do any additional setup after loading the view.
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
