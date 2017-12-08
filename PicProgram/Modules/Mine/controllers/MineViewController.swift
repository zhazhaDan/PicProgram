//
//  MineViewController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController,MineViewProtocol,CustomViewProtocol,UIGestureRecognizerDelegate {
//    var mineView:LogOutView!
    @IBOutlet weak var userBackImageView: UIImageView!
    @IBOutlet weak var userIconButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cScrollView: UIScrollView!
    var deviceDatas:Array<[String:Any]> = [["device_id":"1","device_name":"某人的数字画框","flag":1],["device_id":"2","device_name":"某人的智能画框","flag":1],["device_id":"3","device_name":"智能画框","flag":0],["device_id":"4","device_name":"数字画框","flag":0]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.userIconButton.xs_setImage(UserInfo.user.head_url, "08weidenglu_yonghu_touxiang", state: .normal)
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
        self.userIconButton.layer.cornerRadius = self.userIconButton.width/2
        self.userIconButton.layer.masksToBounds = true
        self.userIconButton.layer.borderWidth = 2
        self.userIconButton.layer.borderColor = xsColor_main_white.cgColor
        let deviceView = Bundle.main.loadNibNamed("DeviceManageView", owner: nil, options: nil)?.first as! DeviceManageView
        deviceView.cDelegate = self
        deviceView.frame = bottomView.bounds
        self.bottomView.addSubview(deviceView)
//        self.contentView.height = self.bottomView.bottom
//        self.contentView.updateConstraints()
//        self.cScrollView.contentSize = CGSize.init(width: cScrollView.width, height: contentView.bottom)
//        self.cScrollView.updateConstraints()
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
        tapGesture.delegate = self
        backView.addGestureRecognizer(tapGesture)
        let bindView = Bundle.main.loadNibNamed("MineBindDeviceView", owner: nil, options: nil)?.first as! MineBindDeviceView
        bindView.frame = CGRect.init(x: 0, y: self.view.height - 209, width: self.view.width, height: 209)
        bindView.dataSource = deviceDatas
        bindView.delegate = self
        backView.tag = 100
        bindView.tableView.reloadData()
        backView.addSubview(bindView)
        self.view.addSubview(backView)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func tapRegistAction() {
        let backView = self.view.viewWithTag(100)
        backView?.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addDeviceSelected() {
        let qrView = Bundle.main.loadNibNamed("ScanCodeView", owner: nil, options: nil)?.first as! ScanCodeView
        qrView.frame = bottomView.bounds
        bottomView.addSubview(qrView)
    }
    func backSelectd() {
        
    }
    
    func wifiManageSelected() {
        
    }
    
    ///
    func listDidSelected(view: UIView, at index: Int, _ section: Int) {
        if view.isKind(of: MineBindDeviceView.self) {
            let item = deviceDatas[index]
            network.requestData(.user_get_device_info, params: ["device_id":item["device_id"] as! String], finishedCallback: { (result) in
                if result["ret"] as! Int == 0 {
                    let bindUserView = Bundle.main.loadNibNamed("DeviceBindUserView", owner: nil, options: nil)?.first as! DeviceBindUserView
                    bindUserView.frame = CGRect.init(x: 0, y: self.view.height - 209, width: self.view.width, height: 209)
                    bindUserView.dataSource = self.deviceDatas
                    let backView = self.view.viewWithTag(100)
                    bindUserView.tableView.reloadData()
                    backView?.addSubview(bindUserView)
                    
                }
            }, nil)
        }
    }

    //为了解决tableivew didselect和tableivew.superview添加手势之后的冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if  (touch.view?.height)! < self.view.height {
            return false
        }
        return true
    }
    
}
