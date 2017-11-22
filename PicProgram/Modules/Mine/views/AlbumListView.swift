//
//  AlbumListView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/22.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class AlbumListView: BaseView,UITableViewDelegate,UITableViewDataSource {
    var dataSource:[Any] = Array()
    open weak var delegate:CustomViewProtocol!
    var tableView:UITableView!
    var _showFrame:CGRect!
    var showFrame:CGRect{
        set {
            _showFrame = newValue
            tableView.frame = _showFrame
        }
        get {
            return _showFrame
        }
    }
    var isShow:Bool = false
    override func buildUI() {
        self.clipsToBounds = true
        tableView = UITableView.init(frame: self.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ((UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController).selectedViewController as! HomePageNavigationController).view.addSubview(tableView)
       self.addSubview(tableView)
    }
    
    func showList() {
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = self.showFrame
        }, completion: { (finished) in
            if finished == true {
                self.isShow = true
                self.isUserInteractionEnabled = true
            }
        })
    }
    
    func hideList(){
        self.isShow = false
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.26) {
            self.height = 0
        }
    }
    
    func showAlbum() {
        self.dataSource = GDPhotoTool.defaultTool.getAllAlbums()
        self.tableView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = (dataSource[indexPath.row] as! PHAssetCollection).localizedTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.listDidSelected!(view: self, at: indexPath.row)
    }
    
    //MARK: private func
    func transformAblumTitle(title: String) -> NSString {
        if title == "Slo-mo" {
            return "慢动作"
        }else if title == "Recently Added" {
            return "最近添加"
        }else if title == "Favorites" {
            return "最爱"
        }else if title == "Recently Deleted" {
            return "最近删除"
        }else if title == "All Photos" {
            return "所有照片"
        }else if title == "Videos" {
            return "视频"
        }else if title == "Selfies" {
            return "自拍"
        }else if title == "Screenshots" {
            return "屏幕快照"
        }else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title as NSString
    }
    
}
