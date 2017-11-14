//
//  Extension+UIView.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/14.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func buildSystemUI() {
        let image = UIImage.init(named: "button_big")
        let hightImage = UIImage.init(named: "button_big")
        self.setBackgroundImage(image, for: .normal)
        self.setBackgroundImage(hightImage, for: .highlighted)
    }
}
