//
//  UserViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/20.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController,SystemPicsCollectionProtocol {
    
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
            vc.delegate = self
            vc.picType = (sender.view?.tag == 10 ? .header : .background)
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
            self.genderLabel.text = (gender as! String)
            let genderTitles = ["男","女","其他"]
            self.updateUserInfo(params: [User_gender:genderTitles.index(of: gender as! String) as Any])

        }
        self.view.addSubview(genderView)
    }
    
    func chooseBirthday() {
        let birthView = BasePickerView.init(frame: CGRect.init(x: 0, y: self.view.height - 190, width: self.view.width, height: 190))
        birthView.type = .birthday
        birthView.buildUI(type: .birthday) { (date) in
            let dateString = Date.formatterDateString(date as AnyObject) as NSString
            self.birthdayLabel.text = dateString as String
            //
            self.updateUserInfo(params:
                [User_birth_year:Int(dateString.substring(with: NSRange.init(location: 0, length: 4))),
                 User_birth_month:Int(dateString.substring(with: NSRange.init(location: 5, length: 2))),
                 User_birth_day:Int(dateString.substring(with: NSRange.init(location: 8, length: 2))) as Any])
        }
        self.view.addSubview(birthView)
    }
    func finishUpload(imageInfo: [String : Any], type: SystemPicType) {
        if type == .header {
            self.headerImageView.image = (imageInfo["image"] as! UIImage)
            if imageInfo["imageUrl"] != nil {
                updateUserInfo(params: [User_head_url:imageInfo["imageUrl"] ?? ""])
            }
        }else if type == .background {
            self.backImageView.image = (imageInfo["image"] as! UIImage)
            if imageInfo["imageUrl"] != nil {
                updateUserInfo(params: [User_background:imageInfo["imageUrl"] ?? ""])
            }
        }
    }
    
    func updateUserInfo(params:[String:Any]) {
        network.requestData(.user_set_info, params: params, finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: "保存成功", delay: 0.5, view: self.view, complete: nil)
            }
        }, nil)
    }
    
}
