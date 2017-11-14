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
        titleLabel = UILabel.initializeLabel(self.bounds, font: 12, textColor: xsColor_main_yellow, textAlignment: .center)
        nextButton = UIButton.init(frame: CGRect.init(x: 0, y: 9, width: 24, height: 24))
        nextButton.setImage(#imageLiteral(resourceName: "01faxian_jinrituijian_fanhui"), for: .normal)
        self.addSubview(titleLabel)
        self.addSubview(nextButton)
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        titleLabel.frame = self.bounds
        titleLabel.reloadWidth()
        titleLabel.x = (self.width - titleLabel.width)/2 - 12
        nextButton.x = titleLabel.right
    }
}
