//
//  SettingViewController.swift
//  PicProgram
//
//  Created by sliencio on 2017/11/29.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "CellReuseIdentifier"

class SettingViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    var dataSource:[String] = [MRLanguage(forKey: "About Us"),MRLanguage(forKey: "FeedBack"),MRLanguage(forKey: "Current Version"),MRLanguage(forKey: "Language"),MRLanguage(forKey: "Cache"),MRLanguage(forKey: "Account Security")]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0 )
        self.title = MRLanguage(forKey: "Mine Setting")
        if UserInfo.user.checkUserLogin() {
            loginButton.setTitle(MRLanguage(forKey: "Sign Out"), for: .normal)
        }else {
            loginButton.setTitle(MRLanguage(forKey: "Sign In"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUDTool.hide()
    }
    
    
    
    @IBAction func logoutAction(_ sender: Any) {
    
        if UserInfo.user.checkUserLogin() {
            logout()
        }else {
            let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
            let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
            self.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)
        }
        
    }
    func logout() {
        let alert = BaseAlertController.inits("", message: MRLanguage(forKey: "Are you sure to sign out?"), confirmText: MRLanguage(forKey: "Yes"), MRLanguage(forKey: "No")) { (tag) in
            if tag == 0 {
                network.requestData(.user_logout, params: nil, finishedCallback: { (result) in
                    if result["ret"] as! Int == 0 {
                        UserInfo.user.localLogout()
                        self.navigationController?.popViewController(animated: true)
                        // mineView更新
                        let normalAttris = [NSAttributedStringKey.foregroundColor:xsColor_main_yellow,NSAttributedStringKey.font:xsFont(10)]
                        let selectedAttris = [NSAttributedStringKey.foregroundColor:xsColor_main_blue,NSAttributedStringKey.font:xsFont(10)]
                        
                        let minVC = MineViewController.init(nibName: "MineViewController", bundle: Bundle.main)
                        minVC.tabBarItem = UITabBarItem.init(title: MRLanguage(forKey: "My Account"), image: UIImage.init(named: "weixuanzhongwode_icon")?.withRenderingMode(.alwaysOriginal), selectedImage:  #imageLiteral(resourceName: "xuanzhongwode_icon").withRenderingMode(.alwaysOriginal))
                        
                        minVC.tabBarItem.setTitleTextAttributes(normalAttris, for: .normal)
                        minVC.tabBarItem.setTitleTextAttributes(selectedAttris, for: .selected);                 self.navigationController?.viewControllers[0] = minVC
                    }else {
                        HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
                    }
                }, nil)
            }
        }
//        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellReuseIdentifier)
            cell?.textLabel?.textColor = xsColor_main_yellow
            cell?.textLabel?.font = xsFont(15)
//            cell?.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "next"))
            cell?.detailTextLabel?.font = xsFont(12)
            cell?.detailTextLabel?.textColor = xsColor_placeholder_grey
            cell?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = dataSource[indexPath.row]
        if [0,3,5].contains(indexPath.row){
            cell.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "next"))
        }else{
            cell.accessoryView = nil
        }
        if cell.textLabel?.text == MRLanguage(forKey: "FeedBack") {
            //TODO:修改
            cell.detailTextLabel?.text = "34445432@qq.com"
        }else if cell.textLabel?.text == MRLanguage(forKey: "Current Version") {
            //TODO:修改
            cell.detailTextLabel?.text = "\(majorVersion)"
        }else if cell.textLabel?.text == MRLanguage(forKey: "Cache") {
            //TODO:修改
            cell.detailTextLabel?.text = "\(getCacheSize())M"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = AboutUsViewController.init(nibName: "AboutUsViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(vc, animated: true)
            print("\(indexPath.row)")
        case 1:
            let vc = ReportViewController.init(nibName: "ReportViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            print("软件版本")
        case 3:
             BaseAlertController.inits("", message: MRLanguage(forKey: "Choose your language"), confirmText: MRLanguage(forKey: "Chinese"), MRLanguage(forKey: "English"), subComplete: { (index) in
               
                if index == 0 {
                    if BaseBundle.language != CNS {
                        HUDTool.show(.loading, view: UIApplication.shared.keyWindow!)
                        BaseBundle.language = CNS.self
                    }
                }else {
                    if BaseBundle.language != EN {
                        HUDTool.show(.loading, view: UIApplication.shared.keyWindow!)
                        BaseBundle.language = EN
                    }
                }
            })
//            self.navigationController?.present(alert, animated: true, completion: nil)
//            self.navigationController?.pushViewController(alert, animated: true)
        case 4:
            clearCache()
        case 5:
            let vc = AccountSafeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
//            let alert = BaseAlertController.inits("温馨小提示", message: "程序媛妹子正在加班加点赶制功能，不要着急哦,有功能、UI、bug之类的问题请先和谢建宇联系~", confirmText: "谢谢理解", nil, subComplete: nil)
//            self.present(alert, animated: true, completion: nil)
            print("\(indexPath.row)")
        }
    }
    
    func getCacheSize()->Int{
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 打印路径,需要测试的可以往这个路径下放东西
        print(cachePath)
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        var big = Int();
        
        // 快速枚举取出所有文件名
        for p in files!{
            // 把文件名拼接到路径中
            let path = cachePath!.appendingFormat("/\(p)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc,bcd) in floder {
                // 只去出文件大小进行拼接
                if abc == FileAttributeKey.size{
                    big += (bcd as AnyObject).integerValue
                }
            }
        }
        return big/(1024*1024)
    }
    
    //清楚系统缓存代码
    func clearCache(){
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        let big = getCacheSize();
        // 提示框
        let message = "\(big)Mb\(MRLanguage(forKey: "Cache"))"
        
        BaseAlertController.inits(MRLanguage(forKey: "Clean Cache"), message: message, confirmText: MRLanguage(forKey: "Yes"), MRLanguage(forKey: "No")) { (tag) in
            if tag == 0 {
                for p in files!{
                    // 拼接路径
                    let path = cachePath!.appendingFormat("/\(p)")
                    // 判断是否存在，以及是否可以删除
                    if(FileManager.default.fileExists(atPath: path) && FileManager.default.isDeletableFile(atPath: path)){
                        // 删除
                        //try! NSFileManager.defaultManager().removeItemAtPath(path)
                        do {
                            try FileManager.default.removeItem(atPath: path as String)
                        } catch {
                            print("removeItemAtPath err"+path)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        
    }
}
