//
//  SharePlatformView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class SharePlatformView: BaseXibView {
    open weak var delegate : SharePlatformProtocol!
    @IBAction func platChooseAction(_ sender: UIButton) {
        delegate.share!(toPlatform: sender.tag - 40)
    }
    
}

@objc protocol SharePlatformProtocol:NSObjectProtocol {
    @objc optional func share(toPlatform index:Int)
}
