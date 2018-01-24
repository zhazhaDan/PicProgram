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
    func xs_setImage(_ imageUrl:String, imageSize:XSImageSize = .image_0, _ placeholderImage:String = "logo_white",forceRefresh:Bool = false){
        self.backgroundColor = xsColor_main_background
        if placeholderImage == "logo_white" {
            self.contentMode = .scaleAspectFit
        }
        var url = "\(imageUrl)_\(imageSize.rawValue)"
//        if imageSize == .image_0 {
            url = imageUrl
//        }
        var options:Array<KingfisherOptionsInfoItem> = [.transition(.fade(1))]
        if forceRefresh == true {
            options.append(.forceRefresh)
        }
        self.kf.setImage(with: URL.init(string: url), placeholder: UIImage.init(named: placeholderImage), options: options, progressBlock: { (receivedSize, totalSize) in
           
        }) { (image, error, cacheType, imageUrl) in
            if image != nil && placeholderImage == "logo_white" {
                self.contentMode = .scaleAspectFill
            }
        }
    }
}


extension UIButton {
    func xs_setImage(_ imageUrl:String, _ placeholderImage:String = "logo_white", state:UIControlState = .normal, _ backgroundColor:UIColor = xsColor_main_background,forceRefresh:Bool = true){
        self.backgroundColor = backgroundColor
        var options:Array<KingfisherOptionsInfoItem> = [.transition(.fade(1))]
        if forceRefresh == true {
            options.append(.forceRefresh)
        }
        self.kf.setImage(with: URL.init(string: imageUrl), for: state, placeholder: UIImage.init(named: placeholderImage), options: options, progressBlock: { (receivedSize, totalSize) in
            
        }) { (image, error, cacheType, imageUrl) in
            
        }}
}
