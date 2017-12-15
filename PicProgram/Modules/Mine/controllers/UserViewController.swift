//
//  UserViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/20.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var localLabel: UITextField!
    @IBOutlet weak var introduceTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的资料"
        // Do any additional setup after loading the view.
    }

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 10 || sender.view?.tag == 11 {
            let vc = SystemPicsCollectionViewController.init(nibName: "SystemPicsCollectionViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.view?.tag == 12 {
            chooseGender()
        }else if sender.view?.tag == 13 {
            chooseBirthday()
        }else {
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func chooseGender() {
        let genderView = BasePickerView.init(frame: CGRect.init(x: 0, y: self.view.height - 140, width: self.view.width, height: 140))
        genderView.type = .gender
        genderView.buildUI(type: .gender) { (gender) in
            self.genderLabel.text = gender as! String
        }
        self.view.addSubview(genderView)
    }
    
    func chooseBirthday() {
        let birthView = BasePickerView.init(frame: CGRect.init(x: 0, y: self.view.height - 190, width: self.view.width, height: 190))
        birthView.type = .birthday
        birthView.buildUI(type: .birthday) { (date) in
            self.birthdayLabel.text = Date.formatterDateString(date as AnyObject)
        }
        self.view.addSubview(birthView)
    }
   
}
