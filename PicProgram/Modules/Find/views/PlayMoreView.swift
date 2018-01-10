//
//  PlayMoreView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/9.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PlayMoreView: BaseView {
    @IBOutlet weak var collectButton: UIButton!
    open weak var delegate:PlayMoreProtocol!
    private var _isCollected:Bool = false
    var isCollected:Bool {
        set {
            _isCollected = newValue
            self.collectButton.isSelected = isCollected
            if isCollected == true {
                self.collectButton.setImage(self.collectButton.image(for: .selected), for: .highlighted)
            }else {
                self.collectButton.setImage(self.collectButton.image(for: .normal), for: .highlighted)
            }
        }
        get {
            return _isCollected
        }
    }
    @IBAction func hidenView(_ sender: UIGestureRecognizer? = nil) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        collectButton.isSelected = isCollected
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        hidenView()
        switch sender.tag - 10 {
        case 0:
            delegate.detailInfo!()
        case 1:
            if isCollected == true {
                delegate.cancelCollectPicture!()
            }else {
                delegate.collectPicture!()
            }
        case 2:
            delegate.addEmotion!()
        default:
            print("other")
        }
    }
    
    @IBAction func timeAction(_ sender: UIButton) {
        for i in 0 ..< 5 {
            let btn = self.viewWithTag(20+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
                delegate.playTimeSetting!(time: i)
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
                delegate.playModeSetting!(mode: i)
            }else {
                btn.isSelected = false
            }
        }
    }
}

@objc protocol PlayMoreProtocol:NSObjectProtocol {
    @objc optional func detailInfo()
    @objc optional func collectPicture()
    @objc optional func cancelCollectPicture()
    @objc optional func addEmotion()
    @objc optional func playTimeSetting(time:Int)
    @objc optional func playModeSetting(mode: Int)
}
