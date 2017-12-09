//
//  UIScrollView+Add.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/9.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
extension UIScrollView {
    
    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     
     - returns: The screen shot's image.
     */
    func viewShot() -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
