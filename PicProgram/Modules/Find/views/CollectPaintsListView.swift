//
//  CollectPaintsListView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import CoreData

private let cellReuseIdentify = "CollectPaintsListViewCell"
class CollectPaintsListView: BaseView,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    
    var dataSource:[LocalPaint] = Array()
    let managedObectContext = appDelegate.managedObjectContext
    var pic:Picture!
    var picModel:PictureModel? {
        set {
            let entity = NSEntityDescription.entity(forEntityName: "Picture", in: managedObectContext) as! NSEntityDescription
            pic = NSManagedObject.init(entity: entity, insertInto: managedObectContext) as! Picture
            pic.picture_id = Int64(newValue?.picture_id as! Int)
            pic.picture_url = newValue?.picture_url
        }
        get {
            return nil
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        tapGesture.delegate = self
        loadDatas()
    }
    
    func loadDatas() {
        let fetchRequest: NSFetchRequest<LocalPaint> = LocalPaint.fetchRequest()
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                dataSource = results as! [LocalPaint]
                if dataSource.count == 0 {
                    let entity = NSEntityDescription.entity(forEntityName: "LocalPaint", in: managedObectContext) as! NSEntityDescription
                    let paint = NSManagedObject.init(entity: entity, insertInto: managedObectContext) as! LocalPaint
                    paint.name = "我的收藏画单"
                    dataSource.append(paint)
                    do {
                        try managedObectContext.save()
                    }
                }
                tableView.reloadData()
            }
            
        } catch  {
            fatalError("获取失败")
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentify)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellReuseIdentify)
            cell?.textLabel?.textColor = xsColor_main_yellow
            cell?.textLabel?.font = xsFont(12)
            cell?.detailTextLabel?.textColor = xsColor_main_yellow
            cell?.detailTextLabel?.font = xsFont(10)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage.init(named: "dansuye_xinjianhuadan")
            cell.textLabel?.text = "新建画单"
        }else {
            let paint = dataSource[indexPath.row - 1]
            if paint.cover_url != nil {
                cell.imageView?.xs_setImage(paint.cover_url!)
            }else {
                cell.imageView?.image = UIImage.init(named: "danduye_shouchang")
            }
            cell.textLabel?.text = paint.name
            if paint.pics?.count as! Int > 0  {
                cell.detailTextLabel?.text = "\(paint.pics?.count as! Int)张"
            }else {
                cell.detailTextLabel?.text = nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let paint = dataSource[indexPath.row - 1]
            paint.addToPics(pic)
            pic.localPaint = paint
            do {
                try managedObectContext.save()
                HUDTool.show(.text, text: "收藏成功", delay: 1, view: self, complete: nil)
            }catch {
                
            }
        }
    }
    //为了解决tableivew didselect和tableivew.superview添加手势之后的冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if  (touch.view?.height)! < self.height {
            return false
        }
        return true
    }
    
}
