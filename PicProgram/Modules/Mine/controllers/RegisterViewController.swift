//
//  RegisterViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var emailRegistView: UIView!
    @IBOutlet weak var phoneRegistView: UIView!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var repassTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    var selectedMethod:Int = 0 // 0 邮箱   1 手机号
    var userModel:UserModel = UserModel()
    @IBAction func nextAction(_ sender: Any) {
        //测试代码
        let vc = FindPassInputCodeViewController.init(nibName: "FindPassInputCodeViewController", bundle: Bundle.main
        )
        self.navigationController?.pushViewController(vc, animated: true)
        return
        
        
        if self.passTextfield.text != self.repassTextfield.text {
            HUDTool.show(.text, text: "两次密码不一致,请再次输入", delay: 1, view: self.view, complete: nil)
            return
        }
        
        var hint = "验证码已发送到电子邮件"
        userModel.email = self.emailTextfield.text!
        userModel.phone = self.phoneTextField.text!
        userModel.password = self.passTextfield.text!
        if selectedMethod == 1 {
            hint = "验证码已发送到手机"
        }
        //发送验证码
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
    @IBAction func registMethodAction(_ sender: UIButton) {
        if sender.isSelected == true {
            return
        }
        if sender.tag == 10 {//邮箱注册
            sender.isSelected = true
            (self.view.viewWithTag(11) as! UIButton).isSelected = false
            self.emailRegistView.isHidden = false
            self.phoneRegistView.isHidden = true
            self.emailTextfield.text = nil
        }else if sender.tag == 11 {//手机号注册
            sender.isSelected = true
            (self.view.viewWithTag(10) as! UIButton).isSelected = false
            self.emailRegistView.isHidden = true
            self.phoneRegistView.isHidden = false
            self.phoneTextField.text = nil
        }
        self.passTextfield.text = nil
        self.repassTextfield.text = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
