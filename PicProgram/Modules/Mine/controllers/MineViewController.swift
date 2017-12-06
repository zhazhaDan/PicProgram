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
    var deviceDatas:Array<[String:Any]> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
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
        self.requestData()
        getUserBindDevices()
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
    
   //获取用户绑定设备信息
    func getUserBindDevices() {
        network.requestData(.user_get_device, params: nil, finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                self.deviceDatas = result["device_infos"] as! Array<[String : Any]>
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
            }
        }, nil)
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
        let backView = UIView.init(frame: self.view.bounds)
        backView.backgroundColor = xsColor("000000", alpha: 0.6)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapRegistAction))
        backView.addGestureRecognizer(tapGesture)
        let bindView = Bundle.main.loadNibNamed("MineBindDeviceView", owner: nil, options: nil)?.first as! MineBindDeviceView
        bindView.frame = CGRect.init(x: 0, y: self.view.height - 209, width: self.view.width, height: 209)
        bindView.dataSource = [["device_id":1,"device_name":"某人的数字画框","flag":1],["device_id":2,"device_name":"某人的智能画框","flag":1],["device_id":3,"device_name":"智能画框","flag":0],["device_id":4,"device_name":"数字画框","flag":0]]
        backView.tag = 100
        bindView.tableView.reloadData()
        backView.addSubview(bindView)
        self.navigationController?.tabBarController?.view.addSubview(backView)
//        self.navigationController?.tabBarController?.view.addSubview(bindView)

    }
    
    @objc func tapRegistAction() {
        let backView = self.navigationController?.tabBarController?.view.viewWithTag(100)
        backView?.removeFromSuperview()
    }
    
    func addDeviceSelected() {
        
    }
    func backSelectd() {
        
    }
    
    func wifiManageSelected() {
        
    }

}
