//
//  BindListViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2018/1/23.
//  Copyright © 2018年 龚丹丹. All rights reserved.
//

import UIKit

class BindListViewController: UITableViewController {
    
    var datasource:[String:String] = [MRLanguage(forKey: "phone"):UserInfo.user.phone,MRLanguage(forKey: "email"):UserInfo.user.email]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.imageView?.image = #imageLiteral(resourceName: "phone")
//        cell.textLabel?.text = datasource[indexPath.row][""]
    }
    
}
