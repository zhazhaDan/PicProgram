//
//  MineViewController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController,MineViewProtocol {
//    var mineView:LogOutView!
    @IBOutlet weak var userBackImageView: UIImageView!
    @IBOutlet weak var userIconButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        UserInfo.user.readUserDefaults()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.userIconButton.xs_setImage(UserInfo.user.head_url, "08weidenglu_yonghu_touxiang", state: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.requestData()
    }

    override func buildUI() {
        self.userIconButton.layer.borderWidth = 2
        self.userIconButton.layer.borderColor = xsColor_main_white.cgColor
        let deviceView = Bundle.main.loadNibNamed("DeviceManageView", owner: nil, options: nil)?.first as! DeviceManageView
        deviceView.cDelegate = self
        deviceView.frame = contentView.bounds
        self.contentView.addSubview(deviceView)

    }
    
    override func requestData() {
        UserInfo.user.updateUserInfo {[weak self] in
            self?.userIconButton.xs_setImage(UserInfo.user.head_url, "08weidenglu_yonghu_touxiang", state: .normal)
        }
    }
   
    func headerDidSelected() {
        if UserInfo.user.checkUserLogin() == false {
            let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
            let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
            self.present(HomePageNavigationController.init(rootViewController: login), animated: true, completion: nil)
        }else {//点击前往个人资料
            let vc = UserViewController.init(nibName: "UserViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func headerAction(_ sender: Any) {
        headerDidSelected()
    }
    @IBAction func settingAction(_ sender: Any) {
        settingDidSelected()
    }
    
    @IBAction func playAction(_ sender: Any) {
    }
    
    func settingDidSelected() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deviceManageSelected() {
        let bindView = Bundle.main.loadNibNamed("MineBindDeviceView", owner: nil, options: nil)?.first as! MineBindDeviceView
        bindView.frame = CGRect.init(x: 0, y: self.view.height - 209, width: self.view.width, height: 209)
        self.contentView.addSubview(bindView)

    }
    
    func addDeviceSelected() {
        
    }
    func backSelectd() {
        
    }
    
    func wifiManageSelected() {
        
    }

}
