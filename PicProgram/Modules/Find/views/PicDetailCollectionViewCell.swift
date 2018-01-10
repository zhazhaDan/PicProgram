//
//  PicDetailCollectionViewCell.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/2.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PicDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var picImageView: UIImageView!
    var _model:PictureModel!
    var model:PictureModel {
        set{
            _model = newValue
            picImageView.xs_setImage(_model.picture_url)
            if _model.detail_url != nil && _model.detail_url.count as! Int > 0 {
                picImageView.xs_setImage(_model.detail_url)
            }

        }
        get{
            return _model
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
