//
//  UserProtocolViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2018/1/3.
//  Copyright © 2018年 龚丹丹. All rights reserved.
//

import UIKit

class UserProtocolViewController: UIViewController {
    var userModel:UserModel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBAction func agreeAction(_ sender: Any) {
        let registVC = RegisterViewController.init(nibName: "RegisterViewController", bundle: Bundle.main)
        registVC.userModel = self.userModel
        self.navigationController?.pushViewController(registVC, animated: true)

    }
    @IBAction func denyAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
