//
//  PKHUDTextView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDTextView provides a wide, three line text view, which you can use to display information.
open class PKHUDTextView: PKHUDWideBaseView {

    public init(text: String?) {
        super.init()
        commonInit(text)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit("")
    }

    func commonInit(_ text: String?) {
        titleLabel.text = text
        let tmpSize = titleLabel.textSize(200, 200)
        size = CGSize.init(width: tmpSize.width + 40, height: tmpSize.height + 20)
        addSubview(titleLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let padding: CGFloat = 1.0
        titleLabel.frame = bounds.insetBy(dx: padding, dy: padding)
    }

    open let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .center
        label.font = xsFont(17)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        return label
    }()
}
