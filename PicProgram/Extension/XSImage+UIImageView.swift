//
//  XSImage+UIImageView.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/31.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

enum XSImageSize:Int{
    case image_227 = 227
    case image_383 = 383
    case image_640 = 640
    case image_750 = 750
    case image_957 = 957
    case image_1080 = 1080
    case image_1121 = 1121
    case image_1615 = 1615
    case image_0 = 0
}

extension UIImageView {
    func xs_setImage(_ imageUrl:String, imageSize:XSImageSize = .image_0, _ placeholderImage:String = "logo_white"){
        self.backgroundColor = xsColor_placeholder_grey
        self.contentMode = .scaleAspectFit
        var url = "\(imageUrl)_\(imageSize.rawValue)"
//        if imageSize == .image_0 {
            url = imageUrl
//        }
        self.kf.setImage(with: URL.init(string: url), placeholder: UIImage.init(named: placeholderImage), options: [.transition(.fade(1))], progressBlock: { (receivedSize, totalSize) in
           
        }) { (image, error, cacheType, imageUrl) in
            if image != nil {
                self.contentMode = .scaleAspectFill
            }
        }
    }
}


extension UIButton {
    func xs_setImage(_ imageUrl:String, _ placeholderImage:String = "logo_white", state:UIControlState = .normal, _ backgroundColor:UIColor = xsColor_placeholder_grey){
        self.backgroundColor = backgroundColor
        self.kf.setImage(with: URL.init(string: imageUrl), for: state, placeholder: UIImage.init(named: placeholderImage), options: [.transition(.fade(1))], progressBlock: { (receivedSize, totalSize) in
            
        }) { (image, error, cacheType, imageUrl) in
            
        }}
}
