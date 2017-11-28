//
//  EmotionView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

let cellReuseableIdentString = "EmotionCollectionViewCell"

class EmotionView: BaseView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,CustomViewProtocol{
    var dataSource: Array<[String:Any]> = Array()
    open weak var delegate:CustomViewProtocol!
    var collecView:UICollectionView!
    override func buildUI() {
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.sectionInset = UIEdgeInsets.init(top: 20, left: 36, bottom: 20, right: 36)
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 22
        collecView = UICollectionView.init(frame: self.bounds, collectionViewLayout: collectionLayout)
        collecView.dataSource = self
        collecView.delegate = self
        collecView.bounces = false
        collecView.backgroundColor = xsColor_main_white
        collecView.showsHorizontalScrollIndicator = false
        collecView.translatesAutoresizingMaskIntoConstraints = false
        collecView.register(UINib.init(nibName: "EmotionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellReuseableIdentString)
        addSubview(collecView)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.width - 72 - 42)/2, height: (self.width - 72 - 42)/2 + 20)
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
