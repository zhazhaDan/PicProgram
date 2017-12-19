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
    
    
    /// 生成二维码
 func generateQRCodeImage() -> UIImage {
        
        // 1. 生成二维码
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setDefaults()
        qrFilter.setValue(self.data(using: String.Encoding.utf8), forKey: "inputMessage")
        let ciImage = qrFilter.outputImage
        
        // 2. 缩放处理
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        
        // 3. 颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(transformImage, forKey: "inputImage")
        // 前景色
        colorFilter.setValue(CIColor(color: xsColor_main_yellow), forKey: "inputColor0")
        // 背景色
        colorFilter.setValue(CIColor(color: UIColor.white), forKey: "inputColor1")
        
        let outputImage = colorFilter.outputImage
        
        //        return insertAvatarImage(qrimage: UIImage(CIImage: outputImage!), avatar: UIImage(named: "avatar")!)
        return UIImage.init(ciImage: outputImage!)
    }
    
    func insertAvatarImage(qrimage: UIImage, avatar: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(qrimage.size)
        
        let rect = CGRect(origin: CGPoint.zero, size: qrimage.size)
        qrimage.draw(in: rect)
        
        let w = rect.width * 0.2
        let x = (rect.width - w) * 0.5
        let y = (rect.height - w) * 0.5
        avatar.draw(in: CGRect(x: x, y: y, width: w, height: w))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
}
