//
//  LoginViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/11.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController,CustomViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func buildUI() {
//        let customView = LoginView.init(frame: CGRect.init(x: 0, y: NavigationBarBottom, width: self.view.width, height: self.view.height - NavigationBarBottom))
//        customView.c_delegate = self
//        self.view.addSubview(customView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func listDidSelected(at index: Int) {
        switch index {
        case 10:
            print("登录")
        case 11:
            print("注册")
            let vc = RegisterViewController.init(nibName: "RegisterViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(vc, animated: true)
        case 12:
            print("稍后注册")
        case 20:
            print("Facebook")
        default:
            print("bbbb")
        }
    }
}
