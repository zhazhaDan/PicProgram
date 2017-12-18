//
//  BigStarShareView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/19.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BigStarShareView: BaseView {

    @IBOutlet weak var blurView: UIVisualEffectView!
    var cell : ArtMasterSayTableViewCell!
    @IBOutlet weak var contentScrollVIew: UIScrollView!
    @IBOutlet weak var materialButton: UIButton!
    @IBOutlet weak var platformButton: UIButton!
    @IBOutlet weak var chooseView: UIView!
    @IBAction func materialChooseAction(_ sender: UIButton) {
        let images = [#imageLiteral(resourceName: "yishuxianfeng_huise"),#imageLiteral(resourceName: "yishuxianfeng_dakashuo_xuanzhi"),#imageLiteral(resourceName: "yishuxianfeng_mise")]
        self.cell.materialImageView.image = images[sender.tag - 11]
        for i in 0 ..< 3 {
            let btn = self.viewWithTag(11+i)
            if btn == sender {
                sender.layer.cornerRadius = sender.height/2
                sender.layer.borderWidth = 2
                sender.layer.borderColor = xsColor_main_yellow.cgColor
                sender.layer.masksToBounds = true
            }else {
                sender.layer.cornerRadius = 0
                sender.layer.borderWidth = 0
                sender.layer.borderColor = xsColor_main_black.cgColor
                sender.layer.masksToBounds = true
            }
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.chooseView.x = sender.x
        }
        self.contentScrollVIew.setContentOffset(CGPoint.init(x: SCREEN_WIDTH, y: 0), animated: true)
    }
    @IBAction func materialAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.chooseView.x = sender.x
        }
        self.contentScrollVIew.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.removeFromSuperview))
        self.blurView.addGestureRecognizer(tap)
        cell = Bundle.main.loadNibNamed("ArtMasterSayTableViewCell", owner: self, options: nil)?.first as! ArtMasterSayTableViewCell
        cell.frame = CGRect.init(x: 24, y: 183, width: SCREEN_WIDTH - 48, height: 190)
        self.addSubview(cell)

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
