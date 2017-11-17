//
//  FindPassViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class FindPassInputCodeViewController: BaseViewController {
    var userModel:UserModel = UserModel()
    @IBOutlet weak var codeTextfield: UITextField!
    @IBAction func sendCodeAction(_ sender: Any) {
        //测试代码
        let repassVC = ChangePassViewController.init(nibName: "ChangePassViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(repassVC, animated: true)
    }
    @IBAction func resendCodeAction(_ sender: Any) {
        self.requestData()
    }
    
    override func requestData() {
        //发送验证码
//        var str = userModel.email
        var hint = "验证码已发送到电子邮件"
        if userModel.email.count == 0 {
//            str = userModel.phone
            hint = "验证码已发送到手机"
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
