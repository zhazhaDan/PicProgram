//
//  ClassifyBaseListView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ClassifyBaseListView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,CustomViewProtocol{
    var last_id:Int = 0
    var collecView:UICollectionView!
    open weak var delegate:CustomViewProtocol!
    var dataSource: Array<[String:Any]> = Array()

    override func buildUI() {
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.sectionInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 12
        let collecView = UICollectionView.init(frame: self.bounds, collectionViewLayout: collectionLayout)
        collecView.dataSource = self
        collecView.delegate = self
        collecView.bounces = false
        collecView.backgroundColor = xsColor_main_white
        collecView.showsHorizontalScrollIndicator = false
        collecView.translatesAutoresizingMaskIntoConstraints = false
        collecView.register(UINib.init(nibName: "EmotionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellReuseableIdentString)
        addSubview(collecView)
        let path = Bundle.main.path(forResource: "EmotionList", ofType: "plist")
        dataSource = NSArray.init(contentsOfFile: path!) as! Array<[String : String]>
        collecView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.width - 48)/3, height: (self.width - 48)/3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseableIdentString, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate?.listDidSelected) != nil{
            delegate?.listDidSelected!(view: self, at: indexPath.row, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let cell = cell as! EmotionCollectionViewCell
        let dict = dataSource[indexPath.row]
        cell.picImageView.image = UIImage.init(named: dict["imageName"]! as! String)
        cell.nameLabel.text = dict["title"] as! String
    }
}
