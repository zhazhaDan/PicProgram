//
//  ClassifyBaseListView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

let cellReuseIdentifier = "ClassifyCollectionViewCell"
let headerReuseIdentifier = "ClassifyCollectionReusableView"
class ClassifyCommonListView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,CustomViewProtocol{
    var last_id:Int = 0
    var collecView:UICollectionView!
//    var dataSource:Array<BaseObject> = Array()
    open weak var delegate:CustomViewProtocol!
    var _dataSource: Array<[String:Any]> = Array()
    var dataSource: Array<[String:Any]> {
        set {
            _dataSource = newValue
        }
        get {
            return _dataSource
        }
    }

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
        collecView.register(UINib.init(nibName: "ClassifyCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellReuseIdentifier)
        collecView.register(UINib.init(nibName: "ClassifyCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        addSubview(collecView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionData = self.dataSource[section]
        let datas = sectionData["paints"] as! Array<[String:Any]>
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.width - 48)/3, height: (self.width - 48)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 12, 5, 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: self.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionData = self.dataSource[indexPath.section]
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ClassifyCollectionReusableView
            headerView.titleLabel.text = sectionData["type_name"] as! String
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate?.listDidSelected) != nil{
            delegate?.listDidSelected!(view: self, at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let sectionData = self.dataSource[indexPath.section]
        let datas = sectionData["paints"] as! Array<[String:Any]>
        let cell = cell as! ClassifyCollectionViewCell
        let item = datas[indexPath.row]
        cell.picImageView.xs_setImage(item["img_url"] as! String)
        cell.nameLabel.text = item["paint_name"] as! String
    }
}
