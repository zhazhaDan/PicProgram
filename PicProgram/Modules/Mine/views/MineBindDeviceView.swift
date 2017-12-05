//
//  MineBindDevicesView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/2.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit


private let cellReuseIdentifier = "BindDeviceTableViewCell"

class MineBindDeviceView: BaseView,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dataSource: Array<[String:Any]>!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib.init(nibName: "BindDeviceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentify)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellReuseIdentify, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let subCell = cell as! BindUserTableViewCell
        
    }
}
