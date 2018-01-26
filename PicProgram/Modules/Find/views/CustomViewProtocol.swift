//
//  CustomViewProtocol.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/13.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

@objc protocol CustomViewProtocol:NSObjectProtocol {
    @objc optional func listDidSelected(view:UIView,at index:Int, _ section:Int)
    @objc optional func listWillDelete(view:UIView,at index:Int, _ section:Int)
}
