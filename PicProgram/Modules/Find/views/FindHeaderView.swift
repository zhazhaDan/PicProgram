//
//  FindHeaderView.swift
//  PicProgram
//
//  Created by sliencio on 2017/11/8.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class FindHeaderView: BaseView {

    var titleLabel: UILabel!
    var nextButton: UIButton!

    override func buildUI() {
        titleLabel = UILabel.initializeLabel(self.bounds, font: 14, textColor: xsColor_main_yellow, textAlignment: .center)
        nextButton = UIButton.init(frame: CGRect.init(x: 0, y: 9, width: 24, height: 24))
        nextButton.setImage(#imageLiteral(resourceName: "01faxian_jinrituijian_fanhui"), for: .normal)
        nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
        nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
        nextButton.titleLabel?.font = xsFont(14)
        nextButton.setTitleColor(xsColor_main_yellow, for: .normal)
//        self.addSubview(titleLabel)
        self.addSubview(nextButton)
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        titleLabel.frame = self.bounds
        titleLabel.reloadWidth()
        nextButton.width = titleLabel.width + 30
        nextButton.center.x = self.center.x
        nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -titleLabel.width, 0, 0)
        nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabel.width, 0, 0)
    }
}
