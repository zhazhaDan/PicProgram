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
    @IBOutlet weak var listViewHeight: NSLayoutConstraint!
    open weak var delegate:CollectPaintsListProtocol!
    var dataSource:[Paint] = Array()
    let managedObectContext = appDelegate.managedObjectContext
    var pic:Picture!
    var picModel:PictureModel? {
        set {
//            let entity = NSEntityDescription.entity(forEntityName: "Picture", in: managedObectContext) as! NSEntityDescription
//            pic = NSManagedObject.init(entity: entity, insertInto: managedObectContext) as! Picture
            pic = Picture.fetchPicture(forPicId: Int64(newValue?.picture_id as! Int))
//            pic.picture_id = Int64(newValue?.picture_id as! Int)
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
        //监听画单创建通知
        NotificationCenter.default.addObserver(self, selector: #selector(addPaintSuccess(_ : )), name: NSNotification.Name(rawValue: NotificationName_LocalPaintCreateSuccessful), object: nil)
    }
    override func removeFromSuperview() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationName_LocalPaintCreateSuccessful), object: nil)
         super.removeFromSuperview()
    }
    
    @objc func addPaintSuccess(_ notification:NSNotification) {
        dataSource.append(notification.object as! Paint)
        updateUIData()
    }
    
    func loadDatas() {
        dataSource = Paint.fetchAllLocalPaint()!
        if dataSource.count == 0 {
            let paint = Paint.fetchPaint(key: .name, value: MRLanguage(forKey: "My collection"), create: true, painttype: 1)
            dataSource.append(paint!)
            do {
                try appDelegate.managedObjectContext.save()
            }catch{}
        }
        updateUIData()
    }
    
    func updateUIData() {
        listViewHeight.constant = CGFloat(Int(tableView.rowHeight) * (dataSource.count + 1) + 34)
        self.updateConstraints()
        tableView.reloadData()

    }
    
    @IBAction func tapAction(_ sender: Any?) {
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentify)
        if cell == nil {
            cell = CollectPaintsListTableViewCell.init(style: .subtitle, reuseIdentifier: cellReuseIdentify)
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
            cell.textLabel?.text = MRLanguage(forKey: "New Art Work List")
        }else {
            let paint = dataSource[indexPath.row - 1]
            if paint.title_url != nil {
                cell.imageView?.xs_setImage(paint.title_url!)
            }else {
                cell.imageView?.image = UIImage.init(named: "danduye_shouchang")
            }
            cell.textLabel?.text = paint.paint_title
            if paint.pics?.count as! Int > 0  {
                cell.detailTextLabel?.text = "\(paint.pics?.count as! Int)\(MRLanguage(forKey: "pages"))"
            }else {
                cell.detailTextLabel?.text = nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate.listDidSelected(view: self, at: indexPath.row, 0)
        if indexPath.row > 0 {
            let paint = dataSource[indexPath.row - 1]
            if paint.pics?.count == 0 {
                paint.title_url = pic.picture_url
                paint.title_detail_url = pic.detail_url
            }
            paint.addToPics(pic)
            pic.paint = paint
            do {
                try managedObectContext.save()
                HUDTool.show(.text, text: MRLanguage(forKey: "Save successful"), delay: 1, view: self, complete: {
                    self.tapAction(nil)
                })
            }catch {
            }
        }else {
            //添加画单
            delegate.collectionPaintsListAddPaint!()
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

class CollectPaintsListTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.size = CGSize.init(width: 35, height: 35)
        textLabel?.x = 65
        detailTextLabel?.x = 65
        self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0)
    }
  
}

@objc protocol CollectPaintsListProtocol:NSObjectProtocol {
    @objc optional func collectionPaintsListAddPaint()
}
