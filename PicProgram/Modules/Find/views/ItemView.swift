//
//  ItemView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ItemView: BaseView {
    var _model:PaintModel!
    var model:PaintModel {
        set{
            _model = newValue
            self.picImageView.xs_setImage(_model.title_url)
            self.titleLabel.text = _model.paint_title
            self.glanceNumberLabel.text = "\(_model.read_num)"
            self.picsNumberLabel.text = "\(_model.picture_num)张"
        }
        get {
            return _model
        }
    }
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var glanceNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picsNumberLabel: UILabel!
    open weak var delegate:FindViewProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemSelcted))
        self.addGestureRecognizer(tap)
    }
    @objc func itemSelcted() {
        if (model == nil) {
            model = PaintModel()
            model.paint_id = 1
        }
        delegate.viewDidSelected!(view: self, paint_id: model.paint_id)
    }

}


