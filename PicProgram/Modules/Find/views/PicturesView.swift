//
//  PicturesViewController.swift
//  PicProgram
//
//  Created by sliencio on 2017/11/11.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PicDetailCollectionViewCell"

class PicturesView: BaseView,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    open weak var delegate:CustomViewProtocol!
    private var _dataSource:Array<PictureModel> = Array()
    var dataSource:Array<PictureModel> {
        set {
            _dataSource = newValue
            
        }
        get {
            return _dataSource
        }
    }
    var picture_id:Int = 0
    var collecView:UICollectionView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if picture_id == 0 {
//            collecView.reloadData()
//        }else {
//            requestData()
//        }
//        // Do any additional setup after loading the view.
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        requestData()
//    }
//
    
    
    override func buildUI() {
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.sectionInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 12
        collecView = UICollectionView.init(frame: self.bounds, collectionViewLayout: collectionLayout)
        collecView.dataSource = self
        collecView.delegate = self
        collecView.bounces = false
        collecView.backgroundColor = xsColor_main_white
        collecView.showsHorizontalScrollIndicator = false
        collecView.translatesAutoresizingMaskIntoConstraints = false
        collecView.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        self.addSubview(collecView)
        collecView.reloadData()
    }
    
    private let historyPaintName = "我的历史浏览"

 func requestData() {
//        network.requestData(.picture_info, params: ["picture_id":picture_id], finishedCallback: { (result) in
//
//        }, nil)
    let paint = Paint.fetchPaint(key: .name, value: historyPaintName, create: true, painttype: 3)
    do {
        try appDelegate.managedObjectContext.save()
    }catch {}
        dataSource = (paint?.pictureModels)!
        collecView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.width - 36)/3, height: (self.width - 36)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 6, 0, 6)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicDetailCollectionViewCell
        cell.model = dataSource[indexPath.row]
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        delegate.listDidSelected!(view: self, at: indexPath.item, 0)
    }
}
