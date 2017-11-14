//
//  RecommandListCollectionViewCell.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class RecommandListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var eyeNumLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let maskPath = UIBezierPath.init(roundedRect: self.picImageView.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize.init(width: 8, height: 8))
        let maskLayer = CAShapeLayer.init()
        //        maskLayer.frame = self.picImageView.bounds
        maskLayer.path = maskPath.cgPath
        self.picImageView.layer.mask = maskLayer
    }

}
