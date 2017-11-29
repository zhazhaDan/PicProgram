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
    @IBAction func submitChangePassAction(_ sender: Any) {
        network.requestData(.user_reset_password, params: ["register_id":userModel.register_id,"passwrod":userModel.password], finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: "密码重置成功", delay: 1, view: self.view, complete: {
                    let vc = FindPassInputCodeViewController()
                    vc.method = .login_regist
                    vc.userModel = self.userModel
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
