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

let cellReuseIdentifyString = "AlbumTableViewCell"
class AlbumListView: BaseView,UITableViewDelegate,UITableViewDataSource {
    var dataSource:[Any] = Array()
    open weak var delegate:CustomViewProtocol!
    var _tableView:UITableView!
    var tableView:UITableView {
        set {
            _tableView = newValue
        }
        get {
            // CGRect.init(x: self.showFrame.origin.x, y: 0, width: self.showFrame.size.width, height: self.showFrame.size.height)
            if _tableView == nil {
                _tableView = UITableView.init(frame: self.showFrame, style: .plain)
                _tableView.y = 0
                _tableView.delegate = self
                _tableView.dataSource = self
                _tableView.register(UINib.init(nibName: "AlbumTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentifyString)
                ((UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController).selectedViewController as! HomePageNavigationController).view.addSubview(_tableView)
                self.addSubview(_tableView)
            }
            return _tableView
        }
    }
    var _showFrame:CGRect!
    var showFrame:CGRect{
        set {
            _showFrame = newValue
        }
        get {
            return _showFrame
        }
    }
    var isShow:Bool = false
    override func buildUI() {
        self.clipsToBounds = true
       
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
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifyString, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let subCell = cell as! AlbumTableViewCell
        let assetCollection = self.dataSource[indexPath.row] as! PHAssetCollection;
        let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil);
        if fetchResult.count > 0 {
            let asset = fetchResult[0];
            GDPhotoTool.defaultTool.getImage(asset: asset,imageSize: CGSize.init(width: 200, height: 200), complete: { (image, ret) in
                if ret {
                    subCell.picImageview.image = image
                    subCell.picImageview.highlightedImage = image
                }
            })
            subCell.titleLabel.text = assetCollection.localizedTitle
            subCell.subTitleLabel.text =  "\(fetchResult.count)张"
        }
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
