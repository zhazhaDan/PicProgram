//
//  PKHUDRotatingImageView.swift
//  PKHUD
//
//  Created by Mark Koh on 1/14/16.
//  Copyright © 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit
import QuartzCore

/// PKHUDRotatingImageView provides a content view that rotates the supplied image automatically.
open class PKHUDRotatingImageView: PKHUDSquareBaseView, PKHUDAnimating {

    public func startAnimation() {
        imageView.layer.add(PKHUDAnimation.continuousRotation, forKey: "progressAnimation")
        imageView.contentMode = .scaleAspectFit
    }

    public func stopAnimation() {
    }
}
