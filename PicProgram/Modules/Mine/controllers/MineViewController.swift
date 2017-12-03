//
//  MineViewController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController,MineViewProtocol {
    var mineView:LogOutView!
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
        self.mineView.headerButton.xs_setImage(UserInfo.user.head_url, "08weidenglu_yonghu_touxiang", state: .normal)
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
        mineView = LogOutView.init(frame: self.view.bounds)
        mineView.cDelegate = self
        self.view.addSubview(mineView)
    }
    
    override func requestData() {
        UserInfo.user.updateUserInfo {[weak self] in
            self?.mineView.headerButton.xs_setImage(UserInfo.user.head_url, "08weidenglu_yonghu_touxiang", state: .normal)
        }
    }
   
    func headerDidSelected() {
        if UserInfo.user.checkUserLogin() == false {
            let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
            let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
//            self.navigationController?.pushViewController(login, animated: true)
            self.present(HomePageNavigationController.init(rootViewController: login), animated: true, completion: nil)
        }else {//点击前往个人资料
            let vc = UserViewController.init(nibName: "UserViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func settingDidSelected() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
