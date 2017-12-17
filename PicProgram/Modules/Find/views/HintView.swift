//
//  HintView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class HintView: BaseView {

    @IBOutlet weak var hintTextLabel: UILabel!
    @IBAction func tapAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
