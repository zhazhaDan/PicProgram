//
//  RecommandListCollectionViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class RecommandListCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var dataSource:Array<PaintModel> = Array()
    var type:Int = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = xsColor_main_white
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(UINib.init(nibName: "RecommandListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestData()
    }

    
    func requestData() {
        network.requestData(.paint_list, params: ["type_id":type], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                let array = result["paint_arry"] as! Array<[String:Any]>
                for item in array {
                    let model = PaintModel.init(dict:item)
                    self?.dataSource.append(model)
                }
                self?.collectionView?.reloadData()
            }
        }, nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell
        cell.layoutIfNeeded()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        let cell = cell as! RecommandListCollectionViewCell
        cell.picImageView.xs_setImage(model.title_url)
        cell.titleLabel.text = model.paint_title
        cell.numberLabel.text = "\(model.picture_num)张"
        cell.eyeNumLabel.text = "\(model.read_num)"
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout.init()
        let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
        vc.paintModel = dataSource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.view.width - 54-11)/2, height: 219)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(13, 27, 0, 27)
    }
    
}
