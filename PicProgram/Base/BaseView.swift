//
//  BaseView.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/13.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func buildUI() {
        
    }

}

class BaseScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func buildUI() {
        
    }
}
