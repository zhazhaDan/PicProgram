//
//  FontChange+UILabel.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/29.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
extension UILabel {
    @objc func myAwakeFromNib() {
        if self.font.fontDescriptor.postscriptName == ".SFUIText-Regular" {
            let font = xsFont(self.font.pointSize, family: "FZSKBXKJW--GB1-0")
            self.font = font
        }
    }
    
//    private class func swizzleSystemLabel() {
//        let systemAwakeFromNibSelector = #selector(UILabel.awakeFromNib)
//        let myAwakeFromNibSelector = #selector(UILabel.myAwakeFromNib)
//
//        let systemAwakeFromNibMethod = class_getInstanceMethod(self, systemAwakeFromNibSelector)
//        let myAwakeFromNibMethod = class_getInstanceMethod(self, myAwakeFromNibSelector)
//
//        method_exchangeImplementations(systemAwakeFromNibMethod!, myAwakeFromNibMethod!)
//    }
//
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        myAwakeFromNib()
    }
}


extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if self.titleLabel?.font.fontDescriptor.postscriptName == ".SFUIText-Regular" {
            let font = xsFont((self.titleLabel?.font?.pointSize)!, family: "FZSKBXKJW--GB1-0")
            self.titleLabel?.font = font
        }
        
    }
}

extension UITextView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if self.font?.fontDescriptor.postscriptName == ".SFUIText-Regular" {
            let font = xsFont((self.font?.pointSize)!, family: "FZSKBXKJW--GB1-0")
            self.font = font
        }
    }
}

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if self.font?.fontDescriptor.postscriptName == ".SFUIText-Regular" {
            let font = xsFont((self.font?.pointSize)!, family: "FZSKBXKJW--GB1-0")
            self.font = font
        }
    }
}

