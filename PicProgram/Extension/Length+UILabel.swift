//
//  Length+String.swift
//  Xiangshuispace
//            let rect: CGRect = (text as NSString).boundingRectWithSize(CGSizeMake(textWidth, CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.TruncatesLastVisibleLine, NSStringDrawingOptions.UsesFontLeading, NSStringDrawingOptions.UsesLineFragmentOrigin], attributes: dict as? [String : AnyObject], context: nil)

//  Created by 龚丹丹 on 2017/7/13.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    public func textSize(_ tWidth:CGFloat = CGFloat(MAXFLOAT),_ tHeight:CGFloat = CGFloat(MAXFLOAT)) -> CGSize {
        
        let rect = (text! as NSString).boundingRect(with: CGSize.init(width: tWidth, height:tHeight), options: [NSStringDrawingOptions.truncatesLastVisibleLine,NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:font], context: nil)
        return rect.size
    }
    
    
    public func reloadWidth(_ tWidth:CGFloat = CGFloat(MAXFLOAT),_ tHeight:CGFloat = CGFloat(MAXFLOAT)) {
        let size = textSize(tWidth, tHeight)
        width = size.width
        
    }
    
    static func initializeLabel(_ frame: CGRect,font:CGFloat,textColor color:UIColor, textAlignment alignment:NSTextAlignment,_ bold:Bool = false) -> UILabel {
        let label = UILabel.init(frame:frame)
        label.adjustsFontSizeToFitWidth = true
        if bold == true {
            label.font = xsBoldFont(font)
        }else {
            label.font = xsFont(font)
        }
        label.textColor = color
        label.textAlignment = alignment
        return label
    }
}
