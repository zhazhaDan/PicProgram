//
//  MineBindDevicesView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/2.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit


private let cellReuseIdentifier = "BindDeviceTableViewCell"

class MineBindDeviceView: BaseView,UITableViewDelegate,UITableViewDataSource,CustomViewProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    weak open var delegate:CustomViewProtocol!
    var dataSource: Array<[String:Any]> = Array()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib.init(nibName: "BindDeviceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let subCell = cell as! BindDeviceTableViewCell
        let item = dataSource[indexPath.row]
        if item["flag"] as! Int == 1 {
            subCell.adminButton.isHidden = false
        }else {
            subCell.adminButton.isHidden = true
        }
        subCell.deviceNameLabel.text = item["device_name"] as! String
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.listDidSelected!(view: self, at: indexPath.row, 0)
    }
}

