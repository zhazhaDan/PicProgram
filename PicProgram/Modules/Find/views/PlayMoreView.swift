//
//  PlayMoreView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/9.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PlayMoreView: BaseView {

    @IBAction func hidenView(_ sender: UIGestureRecognizer) {
        self.removeFromSuperview()
    }
    @IBAction func moreAction(_ sender: UIButton) {
    }
    
    @IBAction func timeAction(_ sender: UIButton) {
        for i in 0 ..< 4 {
            let btn = self.viewWithTag(20+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
    }
    
    @IBAction func modeAction(_ sender: UIButton) {
        for i in 0 ..< 3 {
            let btn = self.viewWithTag(30+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
