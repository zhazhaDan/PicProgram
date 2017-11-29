//
//  ClassifyArtListViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/24.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PicDetailCollectionViewCell"

class ClassifyArtListViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet weak var classTitleButton: UIButton!
    @IBOutlet weak var showVBackView: UIView!
    @IBOutlet weak var showTableListView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
      var dataSource: Array<[String:Any]>!
    var selectedIndex:Int = 0
    var model:PaintModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        self.title = "分类"
        // Do any additional setup after loading the view.
    }

    override func buildUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier:reuseIdentifier)
        showTableListView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func tapChangePaintAction(_ sender: Any) {
         self.showVBackView.isHidden = !self.showVBackView.isHidden
    }
    
    override func requestData() {
        let paint_id = dataSource[selectedIndex]["paint_id"]
        network.requestData(.paint_info, params: ["paint_id":2], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                self?.model = PaintModel.init(dict: result["paint_detail"] as! [String : Any])
                self?.collectionView?.reloadData()
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.8, view: (self?.view)!, complete: nil)
            }
            }, nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.model == nil {
            return 0
        }
        return model.picture_arry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 48)/3, height: (SCREEN_WIDTH - 48)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 12, 5, 12)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayViewController.player
        vc.dataSource = model.picture_arry
        vc.title = model.paint_title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let cell = cell as! PicDetailCollectionViewCell
        let item = model.picture_arry[indexPath.row]
        cell.model = item
    }
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionData = self.dataSource[indexPath.row]
        cell.textLabel?.text = sectionData["paint_name"] as! String
        if indexPath.row == selectedIndex {
            cell.accessoryView?.isHidden = false
        }else {
            cell.accessoryView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = xsColor_main_yellow
        cell.textLabel?.font = xsFont(12)
        cell.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "04fenlei_yishu-xieshi_xiala_duihao"))
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tapChangePaintAction(tableView)
        self.showTableListView.reloadData()
        self.requestData()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryView?.isHidden = false
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.row == selectedIndex {
            cell?.accessoryView?.isHidden = false
        }else {
            cell?.accessoryView?.isHidden = true
        }

    }
    
    //为了解决tableivew didselect和tableivew.superview添加手势之后的冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if showTableListView.frame.contains(touch.location(in: touch.view)) {
            return false
        }
        return true
    }
    
}
