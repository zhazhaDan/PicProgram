//
//  DeviceManagerViewController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/14.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

enum ManagerType:NSInteger {
    case ManagerType_no_match
    case ManagerType_match_success
}

class DeviceManagerViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource:Array<[String:String]> = Array()
    var type:ManagerType!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func buildUI() {
        let shadowView = ShadowView.shadowView(frame: CGRect.init(x: 10, y: 64, width: view.width - 20, height: 1))
        self.view.addSubview(shadowView)
        
        let imageView = UIImageView.init(frame: CGRect.init(x: (self.view.width - 156)/2, y: 120, width: 156, height: 194))
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.image = UIImage.init(named: "device_unknown")
        
        let deviceStatusLabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.bottom + 10, width: self.view.width, height: 20))
        deviceStatusLabel.font = xsFont(14)
        deviceStatusLabel.textColor = xsColor_title_select
        deviceStatusLabel.textAlignment = .center
        deviceStatusLabel.text = "设备已连接"
        self.view.addSubview(deviceStatusLabel)
        
        
        let tableView = UITableView.init(frame: CGRect.init(x: 20, y: deviceStatusLabel.bottom + 25, width: self.view.width - 40, height: self.view.height - 49 - 64 - shadowView.bottom - 25),style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        self.view.addSubview(tableView)
        
        dataSource = [["title":"设备型号","detail":"XBD-021"],["title":"设备系统","detail":"Android 7.0"],["title":"设备电量","detail":"83%"],["title":"设备存储","detail":"37.86 / 64.00 GB"]]
        
        let button = UIButton.init(frame: CGRect.init(x: 40, y: self.view.height - 30, width: self.view.width - 80, height: 44))
        button.buildSystemUI()
        self.view.addSubview(button)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell?.textLabel?.font = xsFont(13)
            cell?.textLabel?.textColor = xsColor_title_select
            cell?.detailTextLabel?.font = xsFont(13)
            cell?.detailTextLabel?.textColor = xsColor_title_normal
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dict = dataSource[indexPath.row]
        cell.textLabel?.text = dict["title"]
        cell.detailTextLabel?.text = dict["detail"]
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
