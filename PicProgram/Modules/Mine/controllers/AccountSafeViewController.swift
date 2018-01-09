//
//  AccountSafeViewController.swift
//  PicProgram
//
//  Created by sliencio on 2018/1/7.
//  Copyright © 2018年 龚丹丹. All rights reserved.
//

import UIKit

class AccountSafeViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView:UITableView!
    var titles:[String] = [MRLanguage(forKey: "Account"),MRLanguage(forKey: "Change Password")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = MRLanguage(forKey: "Account Security")
        // Do any additional setup after loading the view.
    }
    
    override func buildUI() {
        super.buildUI()
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: NavigationBarBottom + 10, width: self.view.width, height: self.view.height - NavigationBarBottom - 10))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        tableView.rowHeight = 56
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            
            cell?.textLabel?.font = xsFont(15)
            cell?.textLabel?.textColor = xsColor_main_yellow
            cell?.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "next"))
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = titles[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if titles[indexPath.row] == MRLanguage(forKey: "Change Password") {
            let forgetVC = FindPassViewController.init(nibName: "FindPassViewController", bundle: Bundle.main)
            forgetVC.userModel = UserInfo.user
            forgetVC.title = MRLanguage(forKey: "Find Password")
            self.navigationController?.pushViewController(forgetVC, animated: true)
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
