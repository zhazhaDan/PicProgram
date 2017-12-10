//
//  PaintFrameListView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/16.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let cellReuseIdentify = "cellReuseIdentify"
class PaintFrameListView: BaseView,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    var collectionView:UICollectionView!
    var dataSource:[PaintModel] = Array()
    override func buildUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = xsColor_line_grey
        collectionView.register(UINib.init(nibName: "EaselPaintCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: cellReuseIdentify)
        self.addSubview(collectionView)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9//dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.width/3, height: 227)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentify, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let model = dataSource[indexPath.row]
        let subCell = cell as! EaselPaintCollectionViewCell
//        subCell.paintPicImageView.xs_setImage(model.title_url)
        let planks = [#imageLiteral(resourceName: "muwenzuo"),#imageLiteral(resourceName: "muwenzhong"),#imageLiteral(resourceName: "muwenyou")]
        subCell.plankImageView.image = planks[indexPath.row%3]
        subCell.paintTitleLabel.text = "helldoodood"//model.paint_title
        subCell.row = indexPath.row
        
    }
}
