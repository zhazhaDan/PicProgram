//
//  SBLoginViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class SBLoginViewController: BaseViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var mainScrollView: UIScrollView!
    @IBAction func loginAction(_ sender: Any) {
    }
    @IBAction func registAction(_ sender: Any) {
        let registVC = RegisterViewController.init(nibName: "RegisterViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(registVC, animated: true)
    }
    @IBAction func holdRegistAction(_ sender: Any) {
    }
    @IBAction func thirdLoginAction(_ sender: Any) {
    }
    @IBAction func forgetPassAction(_ sender: Any) {
        let forgetVC = FindPassViewController.init(nibName: "FindPassViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainScrollView.contentSize = CGSize.init(width: mainScrollView.width, height: label.bottom + 44)
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
