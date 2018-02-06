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
    func generateQRCodeImage(color:UIColor = xsColor_main_yellow,orientation: UIImageOrientation = UIImageOrientation.up) -> UIImage {
        
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
        colorFilter.setValue(CIColor(color: color), forKey: "inputColor0")
        // 背景色
        colorFilter.setValue(CIColor(color: UIColor.clear), forKey: "inputColor1")
        
        let outputImage = colorFilter.outputImage
        
        //        return insertAvatarImage(qrimage: UIImage(CIImage: outputImage!), avatar: UIImage(named: "avatar")!)
//        return UIImage.init(ciImage: outputImage!)
        let image = UIImage.init(ciImage: outputImage!, scale: 1.0, orientation: orientation)
        if orientation == UIImageOrientation.leftMirrored || orientation == UIImageOrientation.rightMirrored{
            return rotateImage(orientation: orientation, srcImage: image)
        }else {
            return image
        }
    }
    
    func rotateImage(orientation:UIImageOrientation,srcImage:UIImage) -> UIImage {
        //Quartz重绘图片
        let rect = CGRect.init(x: 0, y: 0, width: srcImage.size.width, height: srcImage.size.height)//创建矩形框
        //根据size大小创建一个基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 2)
        let currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
        currentContext?.clip(to: rect)
        switch orientation {
        case .leftMirrored,.rightMirrored:
                currentContext?.rotate(by: CGFloat(M_PI))
        case .up,.upMirrored:
            currentContext?.rotate(by: CGFloat(Double.pi)*4)
        default:
            currentContext?.rotate(by: CGFloat(M_PI))
        }
        //平移， 这里是平移坐标系，跟平移图形是一个道理

        currentContext?.translateBy(x: -rect.size.width, y: -rect.size.height)
        let cgImage = CIContext().createCGImage(srcImage.ciImage!, from: rect)
        currentContext?.draw(cgImage!, in: rect)
        //翻转图片
        let drawImage =   UIGraphicsGetImageFromCurrentImageContext();//获得图片
        return UIImage.init(cgImage: (drawImage?.cgImage)!)
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
