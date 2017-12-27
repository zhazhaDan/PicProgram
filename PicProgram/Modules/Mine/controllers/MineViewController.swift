//
//  MineViewController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController,MineViewProtocol,CustomViewProtocol {
//    var mineView:LogOutView!
    @IBOutlet weak var userBackImageView: UIImageView!
    @IBOutlet weak var userIconButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cScrollView: UIScrollView!
    var deviceDatas:Array<[String:Any]> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        if UserInfo.user.checkUserLogin() == false && appDelegate.isLetterShowed == false && UserInfo.user.letterStatus == 0 {
            appDelegate.isLetterShowed = true
            let vc = LetterViewController()
            self.present(vc, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        HUDTool.hide()
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if UserInfo.user.checkUserLogin() {
            self.requestData()
            getUserBindDevices()
        }
    }

    override func buildUI() {
        self.userIconButton.layer.cornerRadius = self.userIconButton.width/2
        self.userIconButton.layer.masksToBounds = true
        self.userIconButton.layer.borderWidth = 2
        self.userIconButton.layer.borderColor = xsColor_main_white.cgColor
        let deviceView = Bundle.main.loadNibNamed("DeviceManageView", owner: nil, options: nil)?.first as! DeviceManageView
        deviceView.cDelegate = self
        deviceView.tag = 500
        deviceView.frame = bottomView.bounds
        self.bottomView.addSubview(deviceView)
//        self.contentView.height = self.bottomView.bottom
//        self.contentView.updateConstraints()
//        self.cScrollView.contentSize = CGSize.init(width: cScrollView.width, height: contentView.bottom)
//        self.cScrollView.updateConstraints()
    }
    
    override func requestData() {
        UserInfo.user.updateUserInfo {[weak self] in
            self?.userIconButton.xs_setImage(UserInfo.user.head_url, "08weidenglu_yonghu_touxiang", state: .normal,UIColor.clear)
            self?.userNameLabel.text = UserInfo.user.nick_name
        }
    }
   
    func headerDidSelected() {
        if UserInfo.user.checkUserLogin() == false {
            let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
            let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
            self.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)
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
                self.updateDeviceManageView()
            }else if result["ret"] as! Int != -1062 {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
                self.deviceDatas.removeAll()
                self.updateDeviceManageView()
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
        let vc = PlayViewController.player
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func settingDidSelected() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deviceManageSelected() {
        
        if self.deviceDatas.count == 0 {
            return
        }
        let backView = UIView.init(frame: self.view.bounds)
        backView.backgroundColor = xsColor("000000", alpha: 0.6)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapRegistAction))
        tapGesture.delegate = self
        backView.addGestureRecognizer(tapGesture)
        let bindView = Bundle.main.loadNibNamed("MineBindDeviceView", owner: nil, options: nil)?.first as! MineBindDeviceView
        bindView.frame = CGRect.init(x: 0, y: self.view.height - 209, width: self.view.width, height: 209)
        bindView.dataSource = deviceDatas
        bindView.delegate = self
        bindView.tag = 300
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
        if UserInfo.user.checkUserLogin() {
            let qrView = Bundle.main.loadNibNamed("ScanCodeView", owner: nil, options: nil)?.first as! ScanCodeView
            qrView.delegate = self
            qrView.frame = bottomView.bounds
            qrView.tag = 400
            bottomView.addSubview(qrView)
        }else {
            HUDTool.show(.custom, #imageLiteral(resourceName: "icons8-info"), text: MRLanguage(forKey: "Please sign in to add device"), delay: 0.8, view: self.view, complete: nil)
        }
        
        
    }
    func backSelectd() {
        
    }
    
    func wifiManageSelected() {
        if UserInfo.user.checkUserLogin() {
            let wifiView = Bundle.main.loadNibNamed("WifiSettingView", owner: nil, options: nil)?.first as! WifiSettingView
            wifiView.frame = bottomView.bounds
            bottomView.addSubview(wifiView)
        }else {
            HUDTool.show(.custom, #imageLiteral(resourceName: "icons8-info"), text: MRLanguage(forKey: "Please sign in to add device"), delay: 0.8, view: self.view, complete: nil)
        }
        
    }
    
    func scanCode(result: String) {
//        let deviceId = (result as NSString).substring(from: 3)
        network.requestData(.user_bind_device, params: ["device_id":result], finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: "该设备已绑定成功", delay: 0.6, view: self.view, complete: nil)
                self.getUserBindDevices()
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: self.view, complete: nil)
            }
        }, nil)
    }
    
    func updateDeviceManageView() {
        let qrView = self.view.viewWithTag(500) as! DeviceManageView
        if deviceDatas.count == 0 {
            qrView.deviceManageButton.setTitle(MRLanguage(forKey: "Not connected to\nany device"), for: .normal)
        }else {
            qrView.deviceManageButton.setTitle(MRLanguage(forKey: "Device Management"), for: .normal)
        }
    }
    
    ///
    func listDidSelected(view: UIView, at index: Int, _ section: Int) {
        if view.isKind(of: MineBindDeviceView.self) {
            let item = deviceDatas[index]
            network.requestData(.user_get_device_info, params: ["device_id":item["device_id"] as! String], finishedCallback: { (result) in
                if result["ret"] as! Int == 0 {
                    if result["user_infos"] != nil {
                        let bindUserView = Bundle.main.loadNibNamed("DeviceBindUserView", owner: nil, options: nil)?.first as! DeviceBindUserView
                        bindUserView.frame = CGRect.init(x: 0, y: self.view.height - 209, width: self.view.width, height: 209)
                        bindUserView.delegate = self
                        bindUserView.dataSource = result["user_infos"] as! Array<[String : Any]>
                        bindUserView.tag = 200
                        bindUserView.device_id = item["device_id"] as! String
                        let backView = self.view.viewWithTag(100)
                        bindUserView.tableView.reloadData()
                        backView?.addSubview(bindUserView)
                    }
                  
                    
                }
            }, nil)
        }
    }
    
    func denyBindDevice(view: UIView, deviceIndex row: Int) {
        let bindUserView = self.view.viewWithTag(200) as! DeviceBindUserView
        let info = bindUserView.dataSource[row]
        bindUserView.delegate = self
        if info["flag"] as! Int == 1 {
            masterResolveDeviceBindInfo(status: 3, uin: info["uin"] as! Int64)
        }else if info["flag"] as! Int == 2 {
            masterResolveDeviceBindInfo(status: 2, uin: info["uin"] as! Int64)
        }
    }
    func promiseBindDevice(view: UIView, deviceIndex row: Int) {
        let bindUserView = self.view.viewWithTag(200) as! DeviceBindUserView
        let info = bindUserView.dataSource[row]
        masterResolveDeviceBindInfo(status: 1, uin: info["uin"] as! Int64)
    }
    func removeDevice(view: UIView, deviceIndex row: Int) {
        let alert = BaseAlertController.inits("", message: MRLanguage(forKey: "You are going to disconnect this device"), confirmText: MRLanguage(forKey: "Yes"), MRLanguage(forKey: "No"), subComplete: { (tag) in
            if tag == 0 {
                self.confirmRemoveDevice(deviceIndex: row)
            }
        })
        
//        self.navigationController?.present(alert, animated: true, completion: nil)

    }
    
    func confirmRemoveDevice(deviceIndex row: Int) {
        let alert2 = BaseAlertController.inits("", message: MRLanguage(forKey: "If you unbind the device,all that is bound\nto the device.The user will\nautomatically unbundle"), confirmText: MRLanguage(forKey: "Yes"), MRLanguage(forKey: "No"), subComplete: { (tag) in
            if tag == 0 {
                let bindUserView = self.view.viewWithTag(300) as! MineBindDeviceView
                let info = bindUserView.dataSource[row]
                network.requestData(.user_delete_device, params: ["device_id":info["device_id"] as Any], finishedCallback: { (result) in
                    if result["ret"] as! Int == 0{
                        HUDTool.show(.text, text: "设备移除成功", delay: 1, view: (self.navigationController?.view)!, complete: nil)
                        bindUserView.removeFromSuperview()
                        self.tapRegistAction()
                        self.getUserBindDevices()
                    }else {
                        HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: (self.navigationController?.view)!, complete: nil)
                    }
                }, nil)
            }
            
        })
//        self.navigationController?.present(alert2, animated: true, completion: nil)
    }
    
    func masterResolveDeviceBindInfo(status:Int,uin:Int64) {
        let bindUserView = self.view.viewWithTag(200) as! DeviceBindUserView
        network.requestData(.user_master_solve_device, params: ["uin":uin,"status":status,"device_id":bindUserView.device_id], finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: "操作成功", delay: 0.6, view: (self.navigationController?.view)!, complete: {
                    bindUserView.removeFromSuperview()
                })
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: (self.navigationController?.view)!, complete: nil)
            }
        }, nil)
    }

    //为了解决tableivew didselect和tableivew.superview添加手势之后的冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if  (touch.view?.height)! < self.view.height {
            return false
        }
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
}
