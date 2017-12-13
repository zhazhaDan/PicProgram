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
    open weak var  delegate:CustomViewProtocol!
    private var _data:[PaintModel] = []
    var dataSource:[PaintModel] {
        set {
            _data = newValue
            collectionView.reloadData()
        }
        get {
            return _data
        }
    }
    override func buildUI() {
        self.backgroundColor = xsColor_main_red
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
        return dataSource.count + (3 - dataSource.count % 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.width/3, height: 187)
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
        let subCell = cell as! EaselPaintCollectionViewCell
        subCell.row = indexPath.row
        let planks = [#imageLiteral(resourceName: "muwenzuo"),#imageLiteral(resourceName: "muwenzhong"),#imageLiteral(resourceName: "muwenyou")]
        subCell.plankImageView.image = planks[indexPath.row%3]
        if indexPath.row < dataSource.count {
            let model = dataSource[indexPath.row]
            subCell.paintPicImageView.xs_setImage(model.title_url)
            subCell.paintTitleLabel.text = model.paint_title
        }else {
            subCell.paintPicImageView.image = nil
            subCell.paintTitleLabel.text = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < dataSource.count {
            delegate.listDidSelected!(view: self, at: indexPath.item, 0)
        }
    }
}
