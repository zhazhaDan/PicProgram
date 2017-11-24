//
//  Common.swift
//  PhotoSelector
//
//  Created by 龚丹丹 on 17/1/6.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit


//1.swift全局常量
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let StatusBarHeight = UIApplication.shared.statusBarFrame.height
let NavigationBarBottom = StatusBarHeight + 44
let TabbarHeight = (UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController).tabBar.bounds.size.height

let iPhone5 = (SCREEN_WIDTH <= 320 ? true:false)
let iPhone6 = (SCREEN_WIDTH <= 375 ? true:false)
let iPhone6P = (SCREEN_WIDTH <= 414 ? true:false)
let iPhoneScale = SCREEN_HEIGHT/568.0
let fontScale = (iPhone5 == true ? 1:(iPhone6 == true ? 1.1:1.15))
let defaultImageName = "default";

extension UIView {
    var x:CGFloat {
        get {
            return self.frame.origin.x;
        }
        set(newValue) {
            let oldframe = self.frame;
            self.frame = CGRect.init(x: newValue, y: oldframe.origin.y, width: oldframe.size.width, height: oldframe.size.height);
        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.origin.y;
        }
        set(newValue) {
            let oldframe = self.frame;
            self.frame = CGRect.init(x: oldframe.origin.x, y: newValue, width: oldframe.size.width, height: oldframe.size.height);
        }
    }
    
    var width:CGFloat {
        get {
            return self.frame.size.width;
        }
        set {
            let oldframe = self.frame;
            self.frame = CGRect.init(x: oldframe.origin.x, y: oldframe.origin.y, width: newValue, height: oldframe.size.height);

        }
    }
    
    var height:CGFloat {
        get {
            return self.frame.size.height;
        }
        set {
            let oldframe = self.frame;
            self.frame = CGRect.init(x: oldframe.origin.x, y: oldframe.origin.y, width: oldframe.size.width, height: newValue);
            
        }
    }
    
    var right:CGFloat {
        get {
            return self.x+self.width;
        }
        set {
            let oldframe = self.frame;
            self.frame = CGRect.init(x: (self.superview?.width)! - self.width - newValue, y: oldframe.origin.y, width: oldframe.size.width, height: oldframe.size.height);
        }
    }
    
    var bottom:CGFloat {
        get {
            return self.y+self.height;
        }
        set {
            let oldframe = self.frame;
            self.frame = CGRect.init(x: oldframe.origin.x, y: (self.superview?.height)! - self.height - newValue, width: oldframe.size.width, height: oldframe.size.height);
        }
    }
    
    var size:CGSize {
        get {
            return self.bounds.size;
        }
        set {
            self.frame = CGRect.init(x: self.x, y: self.y, width: newValue.width, height: newValue.height);
        }
    }
}
