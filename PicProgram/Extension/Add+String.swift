//
//  Add+String.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/8/9.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
extension String {
    func phoneEncrypt() -> String {
        let index1 = index(startIndex, offsetBy: 3)
        let index2 = index(startIndex, offsetBy: 7)
        let range = Range.init(uncheckedBounds: (lower: index1, upper: index2))
        return  self.replacingCharacters(in: range, with: "****")
    }
    func size(_ tWidth:CGFloat = CGFloat(MAXFLOAT),_ tHeight:CGFloat = CGFloat(MAXFLOAT),_ font:UIFont = xsFont(15)) -> CGSize {
        let rect = (self as NSString).boundingRect(with: CGSize.init(width: tWidth, height:tHeight), options: [NSStringDrawingOptions.truncatesLastVisibleLine,NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:font], context: nil)
        return rect.size
    }
}
