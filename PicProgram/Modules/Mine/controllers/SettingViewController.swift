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
    var dataSource:[String] = ["关于我们","意见反馈","软件版本","语言选择","清除缓存","账户安全"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentify)
        tableView.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0 )
        self.title = LocalizedLanguageTool().getString(forKey: "Mine Setting")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    @IBAction func logoutAction(_ sender: Any) {
        network.requestData(.user_logout, params: nil, finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                UserInfo.user.localLogout()
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
            }
        }, nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentify, for: indexPath)
        cell.textLabel?.textColor = xsColor_main_yellow
        cell.textLabel?.font = xsFont(15)
        cell.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "next"))
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = dataSource[indexPath.row]
        if [0,3,5].contains(indexPath.row){
            cell.accessoryView?.isHidden = false
        }else{
            cell.accessoryView?.isHidden = true
        }
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
