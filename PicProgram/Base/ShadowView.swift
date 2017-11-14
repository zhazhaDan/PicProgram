//
//  ShadowView.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    static func shadowView(frame:CGRect) -> ShadowView {
        
        let view = ShadowView.init(frame: frame)
        view.backgroundColor = xsColor_line_lightgrey
        view.layer.shadowColor = xsColor_main_black.cgColor
        view.layer.shadowOffset = CGSize.init(width: 5, height: 0)
        view.layer.shadowOpacity = 0.6
//        let rect = CGRect.init(x: view.x - 5, y: 5, width: view.width - view.x*2 + 10, height: 3)
//        view.layer.shadowOpacity = 1
//        let squarePath = CGMutablePath()
//        squarePath.addRect(rect)
//        view.layer.shadowPath = squarePath
//        view.layer.shadowColor = xsColor_placeholder_grey.cgColor
//        view.layer.shadowRadius = 3
        return view
    }

}
