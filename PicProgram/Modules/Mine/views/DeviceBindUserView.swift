//
//  MineBindDevicesView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/2.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit


private let cellReuseIdentifier = "BindUserTableViewCell"

class DeviceBindUserView: BaseView,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    open weak var delegate:MineViewProtocol!
    var device_id:String = ""
    var dataSource: Array<[String:Any]>!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "BindUserTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentifier)
    }
    @IBAction func backAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let subCell = cell as! BindUserTableViewCell
        subCell.row = indexPath.row
        let item = dataSource[indexPath.row]
        if item["flag"] as! Int == 1 { // 1已绑定 2已申请
            subCell.adminButton.isHidden = true
            subCell.promiseButton.isHidden = true
            subCell.denyButton.setTitle(MRLanguage(forKey: "Remove"), for: .normal)
        }else {
            subCell.adminButton.isHidden = false
            subCell.promiseButton.isHidden = false
            subCell.denyButton.setTitle(MRLanguage(forKey: "Deny"), for: .normal)
        }
        subCell.delegate = self.delegate
        subCell.userNameLabel.text = item["nick_name"] as! String
    }
}
