//
//  ChangePassViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ChangePassViewController: BaseViewController {
    var userModel:UserModel = UserModel()
    @IBOutlet weak var repassTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var changeTitleLabel: UILabel!
    @IBAction func submitChangePassAction(_ sender: Any) {
        if self.passTextfield.text != self.repassTextfield.text {
            HUDTool.show(.custom, text: MRLanguage(forKey: "Error repassword"), delay: 1, view: self.view, complete: nil)
            return
        }
        
        HUDTool.show(.loading, view: self.view)
        userModel.password = passTextfield.text!
        network.requestData(.user_reset_password, params: ["register_id":userModel.register_id,"password":userModel.password], finishedCallback: { (result) in
            HUDTool.hide()
            if result["ret"] as! Int == 0 {
                HUDTool.show(.custom, text: MRLanguage(forKey: "Reset password successful"), delay: 1, view: self.view, complete: {
                    
                    self.dismiss(animated: true, completion: nil)
                })
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
            }
        }, nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = MRLanguage(forKey: "Find Password")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeTitleLabel.text = "请设置\(userModel.register_id)的新密码，建议使用数字、字母、字符的组合密码，提高密码安全等级。"
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
