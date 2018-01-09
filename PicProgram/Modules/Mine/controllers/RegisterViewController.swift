//
//  RegisterViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController,CustomViewProtocol {

    @IBOutlet weak var emailRegistView: UIView!
    @IBOutlet weak var phoneRegistView: UIView!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var repassTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var areaButton: UIButton!
    
    var barListView:NavigationBarShowListView!
    var phoneAreasTitle:[String] = ["86","77","13","11"]
    
    var selectedMethod:Int = 0 // 0 邮箱   1 手机号
    var userModel:UserModel!
    @IBAction func areaChooseAction(_ sender: Any) {
        if self.barListView == nil {
            self.barListView = NavigationBarShowListView.init(frame:CGRect.init(x: areaButton.x - 20, y: phoneRegistView.bottom, width: areaButton.width + 40, height: 150))
            self.barListView.layer.borderColor = xsColor_main_yellow.cgColor
            self.barListView.layer.borderWidth = 1
            self.barListView.delegate = self
            self.barListView.titles = phoneAreasTitle
        }
        if self.barListView.isShowing == true {
            self.barListView.removeFromSuperview()
        }else {
            self.view.addSubview((self.barListView)!)
        }
        
    }
    @IBAction func nextAction(_ sender: Any) {
//        //测试代码
//        let vc = FindPassInputCodeViewController.init(nibName: "FindPassInputCodeViewController", bundle: Bundle.main
//        )
//        self.navigationController?.pushViewController(vc, animated: true)
//        return
//        
        
        if self.passTextfield.text != self.repassTextfield.text {
            HUDTool.show(.text, text: MRLanguage(forKey: "Error repassword"), delay: 1, view: self.view, complete: nil)
            return
        }
        
        var hint = MRLanguage(forKey: "Verification Code To Your Email")
        userModel.email = self.emailTextfield.text!
        userModel.phone = self.phoneTextField.text!
        userModel.password = self.passTextfield.text!
        if selectedMethod == 1 {
            hint = MRLanguage(forKey: "Verification Code To Your Phone")
        }
        //发送验证码
        HUDTool.show(.loading, view: self.view)
        network.requestData(.user_send_code, params: ["register_id":userModel.register_id], finishedCallback: { (result) in
            HUDTool.hide()
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: hint, delay: 0.8, view: (self.navigationController?.view)!, complete: {
                   
                })
                let vc = FindPassInputCodeViewController()
                vc.method = .login_regist
                vc.userModel = self.userModel
                vc.type = (self.selectedMethod == 0 ? .User_type_email : .User_type_phone)
                vc.title = MRLanguage(forKey: "Sing Up")
                self.navigationController?.pushViewController(vc, animated: true)
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
            selectedMethod = 0
            sender.isSelected = true
            (self.view.viewWithTag(11) as! UIButton).isSelected = false
            self.emailRegistView.isHidden = false
            self.phoneRegistView.isHidden = true
            self.emailTextfield.text = nil
        }else if sender.tag == 11 {//手机号注册
            selectedMethod = 1
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
        self.title = MRLanguage(forKey: "Sign up account")
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap)
    }

    @objc func tapAction() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func listDidSelected(view: UIView, at index: Int, _ section: Int) {
        if view == self.barListView {
            self.areaButton.setTitle("+" + phoneAreasTitle[index], for: .normal)
            self.barListView.removeFromSuperview()
        }
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
