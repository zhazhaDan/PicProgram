//
//  EaselPaintCollectionViewCell.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class EaselPaintCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var paintPicImageView: UIImageView!
    @IBOutlet weak var plankBottomImageView: UIImageView!
    @IBOutlet weak var plankImageView: UIImageView!
    @IBOutlet weak var paintPicRightConstrain: NSLayoutConstraint!
    @IBOutlet weak var paintTitleLabel: UILabel!
    @IBOutlet weak var plankBottomLeftConstrain: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    open weak var  delegate:CustomViewProtocol!
    open weak var  collectionView:PaintFrameListView!
    var _row: Int = 0
    var row:Int {
        set {
            _row = newValue
            if row % 3 == 0 {
                self.plankBottomImageView.image = #imageLiteral(resourceName: "muwenzuobian")
                self.paintPicRightConstrain.constant = 0
//                self.paintTitleLabel.x = self.paintPicImageView.x
                self.plankBottomLeftConstrain.constant = 10
            }else if row % 3 == 2 {
                self.plankBottomImageView.image = #imageLiteral(resourceName: "muwenyoubian")
                self.paintPicRightConstrain.constant = self.width -  self.paintPicImageView.width
//                self.paintTitleLabel.x = self.paintPicImageView.x
                self.plankBottomLeftConstrain.constant = self.width - 10 - self.plankBottomImageView.width
            }else {
                self.plankBottomImageView.image = nil
                self.paintPicRightConstrain.constant = (self.width - self.paintPicImageView.width)/2
                self.paintTitleLabel.x = self.paintPicImageView.x
            }
            self.updateConstraints()
        }
        get {
            return _row
        }
    }
    
    
    
    @objc func showDeleteButton(_ sender: Any) {
        self.deleteButton.isHidden = false
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        delegate.listWillDelete!(view: self.collectionView!, at: row, 0)
    }
    @objc func showPaintDetail(_ sender: UITapGestureRecognizer) {
        delegate.listDidSelected!(view: self.collectionView!, at: row, 0)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showPaintDetail(_:)))
        paintPicImageView.addGestureRecognizer(tap)
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(showDeleteButton(_:)))
        paintPicImageView.addGestureRecognizer(longGesture)
    }

}
