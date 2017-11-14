//
//  shadow+UIView.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/13.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func viewShadow(_ shadowRadiu:CGFloat = 12,_ shadowCornerWidth:CGFloat = 4,_ shadowWidth:CGFloat = 2,_ shadowColor:UIColor = xsColor("7bc9ff")) {
        let rect = CGRect.init(x: -shadowWidth, y: 0, width: width + shadowWidth*2, height: height+6)
        layer.shadowOpacity = 0.4
        let squarePath = CGMutablePath()
        squarePath.addRoundedRect(in: rect, cornerWidth: shadowWidth, cornerHeight: shadowWidth)
        layer.shadowPath = squarePath
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadiu
    }
    
    func allSubviews() -> Array<UIView> {
        var results = self.subviews 
        for view in results {
            results = results + view.allSubviews()
        }
        return results
    }
    
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

