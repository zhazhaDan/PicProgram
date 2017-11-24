//
//  ClassifyArtListViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/24.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PicDetailCollectionViewCell"

class ClassifyArtListViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var classTitleButton: UIButton!
    @IBOutlet weak var showVBackView: UIView!
    @IBOutlet weak var showTableListView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
      var dataSource: Array<[String:Any]>!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func buildUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(PicDetailCollectionViewCell.self, forCellWithReuseIdentifier:reuseIdentifier)
        showTableListView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    override func requestData() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionData = self.dataSource[section]
        let datas = sectionData["paints"] as! Array<[String:Any]>
        return datas.count
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
       
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let sectionData = self.dataSource[indexPath.section]
        let datas = sectionData["paints"] as! Array<[String:Any]>
        let cell = cell as! PicDetailCollectionViewCell
        let item = datas[indexPath.row]
//        cell.picImageView.xs_setImage(item["img_url"] as! String)
    }
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionData = self.dataSource[indexPath.section]
        cell.textLabel?.text = sectionData["type_name"] as! String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }

}
